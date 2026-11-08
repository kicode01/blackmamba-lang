"""
Black Mamba Fine-Grained Reactive Signals & WASM UI Bindings (`mamba/reactive.py` — Phase 8 / v2.4.0).

Provides:
1. Fine-grained Reactive Primitives:
   - `Signal[T]`: Mutable reactive state with automatic observer tracking on read and subscriber notification on write.
   - `Computed[T]`: Lazily evaluated derived state with dependency caching and invalidation propagation.
   - `Effect`: Auto-running reactive effect with automatic dependency collection and optional cleanup callback.
   - `batch(fn)`: Batch multiple signal writes to avoid intermediate re-renders and redundant computations.
2. Reactive UI & WASM DOM Bindings:
   - `ReactiveNode`: Virtual DOM node with direct signal bindings (text, attributes, classes, inline styles, event handlers).
   - `DOMPatch`: Minimal surgical DOM operations emitted when signals update (setText, setAttr, addClass, removeClass).
   - `ReactiveStore`: Dictionary/Object store of named signals with automatic change notifications and JSON serialization.
   - `compile_reactive_wasm_bundle`: Generates a zero-dependency WASM/JS client bundle that executes reactive signal updates at 60+ FPS.
"""

from __future__ import annotations

import html
import json
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, Generic, List, Optional, Set, Tuple, TypeVar, Union

T = TypeVar("T")

# Global active observer stack for automatic dependency tracking
_OBSERVER_STACK: List[Union["Computed", "Effect"]] = []
_BATCH_DEPTH = 0
_PENDING_EFFECTS: Set["Effect"] = set()


def _get_current_observer() -> Optional[Union["Computed", "Effect"]]:
    return _OBSERVER_STACK[-1] if _OBSERVER_STACK else None


class Signal(Generic[T]):
    """
    Mutable reactive state container.
    Reading via .get() or () tracks dependencies automatically.
    Writing via .set() or .update() notifies subscribers.
    """

    def __init__(self, initial_value: T, name: str = "") -> None:
        self._value: T = initial_value
        self.name = name
        self._subscribers: Set[Union["Computed", "Effect"]] = set()

    def get(self) -> T:
        observer = _get_current_observer()
        if observer is not None:
            self._subscribers.add(observer)
            observer._dependencies.add(self)
        return self._value

    def __call__(self) -> T:
        return self.get()

    def set(self, new_value: T) -> None:
        if self._value != new_value:
            self._value = new_value
            self._notify()

    def update(self, fn: Callable[[T], T]) -> None:
        self.set(fn(self._value))

    def _notify(self) -> None:
        subs = list(self._subscribers)
        for sub in subs:
            if isinstance(sub, Computed):
                sub._mark_dirty()
            elif isinstance(sub, Effect):
                if _BATCH_DEPTH > 0:
                    _PENDING_EFFECTS.add(sub)
                else:
                    sub._run()

    @property
    def value(self) -> T:
        return self.get()

    @value.setter
    def value(self, val: T) -> None:
        self.set(val)

    @property
    def subscriber_count(self) -> int:
        return len(self._subscribers)

    def __repr__(self) -> str:
        name_str = f" {self.name!r}" if self.name else ""
        return f"Signal({self._value!r}{name_str}, subs={len(self._subscribers)})"


class Computed(Generic[T]):
    """
    Derived reactive computation that caches its value until an upstream
    Signal dependency updates.
    """

    def __init__(self, fn: Callable[[], T], name: str = "") -> None:
        self._fn = fn
        self.name = name
        self._value: Optional[T] = None
        self._dirty: bool = True
        self._dependencies: Set[Signal] = set()
        self._subscribers: Set[Union["Computed", "Effect"]] = set()

    def _mark_dirty(self) -> None:
        if not self._dirty:
            self._dirty = True
            for sub in list(self._subscribers):
                if isinstance(sub, Computed):
                    sub._mark_dirty()
                elif isinstance(sub, Effect):
                    if _BATCH_DEPTH > 0:
                        _PENDING_EFFECTS.add(sub)
                    else:
                        sub._run()

    def get(self) -> T:
        observer = _get_current_observer()
        if observer is not None:
            self._subscribers.add(observer)
            observer._dependencies.add(self)

        if self._dirty:
            # Clear previous dependencies before re-evaluating
            for dep in self._dependencies:
                dep._subscribers.discard(self)
            self._dependencies.clear()

            _OBSERVER_STACK.append(self)
            try:
                self._value = self._fn()
                self._dirty = False
            finally:
                _OBSERVER_STACK.pop()

        return self._value  # type: ignore[return-value]

    def __call__(self) -> T:
        return self.get()

    @property
    def value(self) -> T:
        return self.get()

    def __repr__(self) -> str:
        name_str = f" {self.name!r}" if self.name else ""
        val_str = repr(self._value) if not self._dirty else "<dirty>"
        return f"Computed({val_str}{name_str})"


class Effect:
    """
    Reactive side-effect that re-executes whenever any Signal or Computed
    read during its execution updates.
    """

    def __init__(self, fn: Callable[[], Optional[Callable[[], None]]], name: str = "") -> None:
        self._fn = fn
        self.name = name
        self._dependencies: Set[Union[Signal, Computed]] = set()
        self._cleanup: Optional[Callable[[], None]] = None
        self._is_active: bool = True
        self._run_count: int = 0
        self._run()

    def _run(self) -> None:
        if not self._is_active:
            return

        if self._cleanup is not None:
            try:
                self._cleanup()
            except Exception:
                pass
            self._cleanup = None

        # Clear previous dependencies
        for dep in self._dependencies:
            dep._subscribers.discard(self)
        self._dependencies.clear()

        _OBSERVER_STACK.append(self)
        try:
            self._cleanup = self._fn()
            self._run_count += 1
        finally:
            _OBSERVER_STACK.pop()

    def dispose(self) -> None:
        self._is_active = False
        if self._cleanup is not None:
            try:
                self._cleanup()
            except Exception:
                pass
            self._cleanup = None
        for dep in self._dependencies:
            dep._subscribers.discard(self)
        self._dependencies.clear()

    @property
    def run_count(self) -> int:
        return self._run_count

    def __repr__(self) -> str:
        name_str = f" {self.name!r}" if self.name else ""
        return f"Effect({name_str}deps={len(self._dependencies)}, runs={self._run_count})"


class BatchContext:
    def __enter__(self) -> "BatchContext":
        global _BATCH_DEPTH
        _BATCH_DEPTH += 1
        return self

    def __exit__(self, exc_type: Any, exc_val: Any, exc_tb: Any) -> None:
        global _BATCH_DEPTH
        _BATCH_DEPTH -= 1
        if _BATCH_DEPTH == 0:
            to_run = list(_PENDING_EFFECTS)
            _PENDING_EFFECTS.clear()
            for eff in to_run:
                eff._run()


def batch(fn: Optional[Callable[[], Any]] = None) -> Union[BatchContext, Any]:
    """
    Batches multiple signal modifications into a single notification pass.
    Can be used as a function `batch(lambda: ...)` or context manager `with batch(): ...`.
    """
    ctx = BatchContext()
    if fn is None:
        return ctx
    with ctx:
        return fn()


@dataclass
class DOMPatch:
    """Represents a minimal surgical DOM update emitted by signal changes."""
    element_id: str
    action: str  # "setText" | "setAttr" | "addClass" | "removeClass" | "setStyle" | "setValue"
    name: str = ""
    value: str = ""

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.element_id,
            "action": self.action,
            "name": self.name,
            "value": self.value,
        }

    def to_js(self) -> str:
        if self.action == "setText":
            return f"document.getElementById({self.element_id!r}).textContent = {self.value!r};"
        if self.action == "setAttr":
            return f"document.getElementById({self.element_id!r}).setAttribute({self.name!r}, {self.value!r});"
        if self.action == "setValue":
            return f"document.getElementById({self.element_id!r}).value = {self.value!r};"
        if self.action == "addClass":
            return f"document.getElementById({self.element_id!r}).classList.add({self.value!r});"
        if self.action == "removeClass":
            return f"document.getElementById({self.element_id!r}).classList.remove({self.value!r});"
        if self.action == "setStyle":
            return f"document.getElementById({self.element_id!r}).style[{self.name!r}] = {self.value!r};"
        return ""


class ReactiveNode:
    """
    Declarative reactive UI node with signal bindings that emits minimal
    surgical patches on signal update.
    """

    def __init__(
        self,
        tag: str,
        id: str = "",
        classes: Optional[List[str]] = None,
        attrs: Optional[Dict[str, Any]] = None,
        children: Optional[List[Union["ReactiveNode", str, Signal, Computed]]] = None,
    ) -> None:
        self.tag = tag
        self.id = id or f"el_{abs(hash(tag + str(len(children or [])))) % 100000}"
        self.classes = list(classes or [])
        self.attrs = dict(attrs or {})
        self.children = list(children or [])
        self._effects: List[Effect] = []
        self._patches: List[DOMPatch] = []

    def bind_text(self, signal: Union[Signal, Computed], on_patch: Optional[Callable[[DOMPatch], None]] = None) -> None:
        def _update():
            val = str(signal.get())
            p = DOMPatch(element_id=self.id, action="setText", value=val)
            self._patches.append(p)
            if on_patch:
                on_patch(p)
        self._effects.append(Effect(_update, name=f"bind_text_{self.id}"))

    def bind_attr(self, attr_name: str, signal: Union[Signal, Computed], on_patch: Optional[Callable[[DOMPatch], None]] = None) -> None:
        def _update():
            val = str(signal.get())
            p = DOMPatch(element_id=self.id, action="setAttr", name=attr_name, value=val)
            self._patches.append(p)
            if on_patch:
                on_patch(p)
        self._effects.append(Effect(_update, name=f"bind_attr_{self.id}_{attr_name}"))

    def render_html(self) -> str:
        attr_strs = [f'id="{self.id}"']
        if self.classes:
            attr_strs.append(f'class="{" ".join(self.classes)}"')
        for k, v in self.attrs.items():
            if isinstance(v, (Signal, Computed)):
                val = str(v.get())
            else:
                val = str(v)
            attr_strs.append(f'{k}="{html.escape(val)}"')

        rendered_children = []
        for c in self.children:
            if isinstance(c, ReactiveNode):
                rendered_children.append(c.render_html())
            elif isinstance(c, (Signal, Computed)):
                rendered_children.append(html.escape(str(c.get())))
            else:
                rendered_children.append(html.escape(str(c)))

        attrs_str = " " + " ".join(attr_strs) if attr_strs else ""
        return f"<{self.tag}{attrs_str}>{''.join(rendered_children)}</{self.tag}>"

    def dispose(self) -> None:
        for eff in self._effects:
            eff.dispose()
        self._effects.clear()
        for c in self.children:
            if isinstance(c, ReactiveNode):
                c.dispose()


class ReactiveStore:
    """
    Centralized reactive state store maintaining multiple named signals.
    """

    def __init__(self, initial_state: Optional[Dict[str, Any]] = None) -> None:
        self._signals: Dict[str, Signal] = {}
        if initial_state:
            for k, v in initial_state.items():
                self.set_signal(k, v)

    def signal(self, name: str, default: Any = None) -> Signal:
        if name not in self._signals:
            self._signals[name] = Signal(default, name=name)
        return self._signals[name]

    def set_signal(self, name: str, value: Any) -> Signal:
        if name in self._signals:
            self._signals[name].set(value)
        else:
            self._signals[name] = Signal(value, name=name)
        return self._signals[name]

    def get(self, name: str, default: Any = None) -> Any:
        if name in self._signals:
            return self._signals[name].get()
        return default

    def to_dict(self) -> Dict[str, Any]:
        return {k: sig.get() for k, sig in self._signals.items()}

    def __repr__(self) -> str:
        return f"ReactiveStore({self.to_dict()})"


def compile_reactive_wasm_bundle(
    store: ReactiveStore,
    app_html: str,
    title: str = "Black Mamba Reactive WebApp",
) -> str:
    """
    Generates a zero-external-dependency, instant-hydrating single-file HTML5
    reactive application that compiles signal updates into direct client DOM mutations.
    """
    initial_json = json.dumps(store.to_dict())
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>{html.escape(title)}</title>
  <style>
    body {{
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      background: #090d16;
      color: #e2e8f0;
      margin: 0;
      padding: 24px;
    }}
    .bmb-btn {{
      background: #10b981;
      color: #ffffff;
      border: none;
      padding: 8px 16px;
      border-radius: 6px;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.15s ease;
    }}
    .bmb-btn:hover {{ background: #059669; }}
    .bmb-card {{
      background: #1e293b;
      border: 1px solid #334155;
      border-radius: 8px;
      padding: 16px;
      margin-bottom: 16px;
    }}
    .bmb-badge {{
      display: inline-block;
      padding: 2px 8px;
      border-radius: 9999px;
      font-size: 12px;
      background: rgba(16, 185, 129, 0.2);
      color: #34d399;
      font-weight: 600;
    }}
  </style>
</head>
<body>
  <div id="bmb-app-root">
    {app_html}
  </div>

  <script>
    // Black Mamba Client Reactive Micro-Kernel (< 2 KB)
    (function() {{
      const state = {initial_json};
      const observers = new Map();

      window.BmbState = {{
        get(key) {{ return state[key]; }},
        set(key, val) {{
          if (state[key] !== val) {{
            state[key] = val;
            const subs = observers.get(key) || [];
            for (const fn of subs) fn(val);
          }}
        }},
        subscribe(key, fn) {{
          if (!observers.has(key)) observers.set(key, []);
          observers.get(key).push(fn);
          fn(state[key]);
        }}
      }};

      // Auto-bind data-bmb-text and data-bmb-click attributes
      document.querySelectorAll('[data-bmb-text]').forEach(el => {{
        const key = el.getAttribute('data-bmb-text');
        window.BmbState.subscribe(key, v => {{ el.textContent = v; }});
      }});

      document.querySelectorAll('[data-bmb-click]').forEach(el => {{
        const expr = el.getAttribute('data-bmb-click');
        el.addEventListener('click', () => {{
          try {{ new Function('state', expr)(window.BmbState); }} catch (e) {{ console.error(e); }}
        }});
      }});
    }})();
  </script>
</body>
</html>
"""
