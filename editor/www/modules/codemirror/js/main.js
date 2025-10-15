
// Build JSON path from filename
function toJsonPath(filename) {
    return `/${filename}`;  // adjust base path as needed
}


// Example file list - ideally loaded from server
const files = ['hello.lua', 'utils.lua', 'config.lua'];
const fileSelect = document.getElementById('fileSelect');

$(document).ready(function () {

    // Load JSON data and set editor value
    async function loadScript(filename) {
        try {
            const response = await fetch(toJsonPath(filename), { method: 'GET' });
            if (!response.ok) throw new Error('Failed to load script');
            const data = await response.json();
            // Assuming JSON has a 'content' field holding the script text
            editor.setValue(data.content || '');
        } catch (e) {
            alert('Error loading script: ' + e.message);
        }
    }

    // Save editor content as JSON
    async function saveScript(filename, content) {
        try {
            const response = await fetch(`/scripts/lua/save`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ filename, content })
            });
            if (!response.ok) throw new Error('Save failed');
            alert('Saved successfully');
        } catch (e) {
            alert('Save error: ' + e.message);
        }
    }

    const editor = CodeMirror(document.getElementById('editor'), {
        mode: 'lua',
        theme: 'monokai',
        lineNumbers: true,
        value: '-- Lua script will load here --'
    });

    // Populate file select dropdown
    files.forEach(file => {
        const option = document.createElement('option');
        option.value = file;
        option.textContent = file;
        fileSelect.appendChild(option);
    });

    document.getElementById('loadBtn').addEventListener('click', () => {
        const filename = fileSelect.value;
        if (!filename) return alert('Select a file to load');
        loadScript(filename);
    });

    document.getElementById('saveBtn').addEventListener('click', () => {
        const filename = fileSelect.value;
        if (!filename) return alert('Select a file to save');
        const content = editor.getValue();
        saveScript(filename, content);
    });

    // Optionally, auto-load first file on startup
    if (files.length > 0) {
        loadScript(files[0]);
    }
})  