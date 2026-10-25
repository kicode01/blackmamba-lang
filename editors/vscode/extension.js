/**
 * Black Mamba VS Code Extension
 * Integrates syntax highlighting and connects to the Black Mamba LSP Daemon.
 */

const vscode = require('vscode');
const net = require('net');
const path = require('path');

let client;

function activate(context) {
    const config = vscode.workspace.getConfiguration('bmb');
    const tcpPort = config.get('lsp.tcpPort', 0);
    const bmbPath = config.get('lsp.path', 'bmb');

    let LanguageClient;
    try {
        LanguageClient = require('vscode-languageclient/node').LanguageClient;
    } catch (e) {
        // vscode-languageclient module not pre-installed in workspace node_modules
        console.log('[Black Mamba] vscode-languageclient not bundled; syntax highlighting active.');
        return;
    }

    let serverOptions;

    if (tcpPort > 0) {
        // Connect to running TCP LSP daemon
        serverOptions = () => {
            const socket = net.connect({ port: tcpPort, host: '127.0.0.1' });
            const result = {
                reader: socket,
                writer: socket
            };
            return Promise.resolve(result);
        };
    } else {
        // Launch LSP daemon over stdio
        serverOptions = {
            command: bmbPath,
            args: ['lsp', '--stdio'],
            options: {
                env: process.env
            }
        };
    }

    const clientOptions = {
        documentSelector: [{ scheme: 'file', language: 'bmb' }],
        synchronize: {
            fileEvents: vscode.workspace.createFileSystemWatcher('**/*.bmb')
        }
    };

    client = new LanguageClient(
        'bmbLanguageServer',
        'Black Mamba Language Server',
        serverOptions,
        clientOptions
    );

    client.start();
    context.subscriptions.push({
        dispose: () => {
            if (client) {
                return client.stop();
            }
        }
    });
}

function deactivate() {
    if (!client) {
        return undefined;
    }
    return client.stop();
}

module.exports = {
    activate,
    deactivate
};
