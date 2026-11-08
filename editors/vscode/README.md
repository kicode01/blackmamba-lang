# TinyTalk & Black Mamba VS Code Extension

Official Visual Studio Code extension for **TinyTalk (`.tnt`)** and **Black Mamba (`.bmb`)** — combining the clean simplicity of Python, the live interactive heritage of Smalltalk, and bare-metal native C speed.

---

## Features

- **Dual Syntax Highlighting**: Full TextMate grammar support for both `.tnt` and `.bmb` source files.
- **Language Server Protocol (LSP 3.17)**:
  - **Real-Time Diagnostics**: As-you-type syntax error squiggles and Cartesian type check diagnostics.
  - **Type Hover Hints**: Rich Markdown tooltips showing inferred types, docstrings, struct layouts, and signatures.
  - **Intelligent Autocompletion**: Triggered on `.` for struct fields and methods, plus scope-aware keywords and builtins.
  - **Go to Definition (`F12`)**: Instantly jump to functions, structs, and variables across your project.
  - **Document Outline / Breadcrumbs**: Hierarchical symbol tree of all structs, fields, and functions.
  - **Code Formatting (`Shift+Alt+F`)**: Canonical 4-space indentation and pipeline operator formatting.

---

## Installation

### Option 1: Install Pre-Built `.vsix`
Download `tinytalk-4.0.0.vsix` from [GitHub Releases](https://github.com/kicode01/tinytalk-lang/releases/tag/v4.0.0) and run:

```bash
code --install-extension tinytalk-4.0.0.vsix
```

### Option 2: Link Extension Folder
Copy or link `editors/vscode` directly into your VS Code extensions folder:

```powershell
# Windows PowerShell:
New-Item -ItemType Junction -Path "$env:USERPROFILE\.vscode\extensions\vscode-tinytalk" -Target "C:\Users\PC\Desktop\mamba\editors\vscode"
```

---

## Extension Settings

| Setting | Default | Description |
| :--- | :--- | :--- |
| `tnt.lsp.path` | `"tnt"` | Command or absolute path to the `tnt` compiler executable. |
| `tnt.lsp.tcpPort` | `0` | Port for connecting to an external TCP LSP daemon (`0` spawns over stdio). |
| `tnt.format.enable` | `true` | Enable canonical 4-space code formatting. |
