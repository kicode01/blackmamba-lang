# Black Mamba VS Code Extension

Official Visual Studio Code extension for the **Black Mamba (`.bmb`)** programming language — high-performance native compiled Python superset with zero-overhead C interop and hardware multithreading.

---

## Features

- **Full Syntax Highlighting**: Keywords, typed declarations (`fn`, `struct`), numeric literals, builtins, string interpolation, and comments.
- **Language Server Protocol (LSP 3.17)**:
  - **Real-Time Diagnostics**: As-you-type syntax error squiggles and type check diagnostics.
  - **Type Hover Hints**: Rich Markdown tooltips showing inferred types, docstrings, struct layouts, and signatures.
  - **Intelligent Autocompletion**: Triggered on `.` for struct fields and methods, plus scope-aware keywords and builtins.
  - **Go to Definition (`F12`)**: Instantly jump to functions, structs, and variables across the file.
  - **Document Outline / Breadcrumbs**: Hierarchical symbol tree of all structs, fields, and functions.
  - **Code Formatting (`Shift+Alt+F`)**: Canonical 4-space indentation and operator formatting.

---

## Installation

### Option 1: Symlink / Copy to VS Code Extensions Directory
Copy or link the `editors/vscode` directory to your VS Code extensions folder:

- **Windows**: `%USERPROFILE%\.vscode\extensions\vscode-black-mamba`
- **Linux / macOS**: `~/.vscode/extensions/vscode-black-mamba`

```bash
# Example on Windows PowerShell:
New-Item -ItemType Junction -Path "$env:USERPROFILE\.vscode\extensions\vscode-black-mamba" -Target "C:\Users\PC\Desktop\mamba\editors\vscode"
```

### Option 2: Package with `vsce`
```bash
npm install -g @vscode/vsce
cd editors/vscode
npm install
vsce package
code --install-extension vscode-black-mamba-0.5.0.vsix
```

---

## Extension Settings

| Setting | Default | Description |
| :--- | :--- | :--- |
| `bmb.lsp.path` | `"bmb"` | Command or absolute path to the `bmb` compiler executable. |
| `bmb.lsp.tcpPort` | `0` | Port for connecting to an external TCP LSP daemon (`0` spawns over stdio). |
| `bmb.format.enable` | `true` | Enable canonical 4-space code formatting. |
