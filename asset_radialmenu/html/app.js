const app = document.getElementById('app');
const itemsEl = document.getElementById('items');
const titleEl = document.getElementById('title');
const subtitleEl = document.getElementById('subtitle');
const centerEl = document.getElementById('center');

let open = false;

function resource() {
    return GetParentResourceName();
}

function post(name, data = {}) {
    fetch(`https://${resource()}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data)
    });
}

function closeMenu() {
    post('close');
}

function render(items) {
    itemsEl.innerHTML = '';

    const count = items.length;
    const radius = 230;

    items.forEach((item, i) => {
        const button = document.createElement('div');
        button.className = 'item';

        const angle = (-Math.PI / 2) + (i * ((Math.PI * 2) / count));
        const x = Math.cos(angle) * radius;
        const y = Math.sin(angle) * radius;

        button.style.left = `calc(50% + ${x}px)`;
        button.style.top = `calc(50% + ${y}px)`;

        button.innerHTML = `
            <div class="icon">${item.icon || '•'}</div>
            <div class="label">${item.label || item.id}</div>
        `;

        button.addEventListener('click', () => {
            post('select', {
                id: item.id,
                action: item.action
            });
        });

        itemsEl.appendChild(button);
    });
}

window.addEventListener('message', (event) => {
    const data = event.data || {};

    if (data.type === 'open') {
        open = true;
        app.classList.remove('hidden');

        titleEl.textContent = data.title || 'RADIAL MENU';
        subtitleEl.textContent = data.subtitle || '';
        render(data.items || []);
    }

    if (data.type === 'close') {
        open = false;
        app.classList.add('hidden');
        itemsEl.innerHTML = '';
    }
});

centerEl.addEventListener('click', closeMenu);

document.querySelector('.backdrop').addEventListener('click', closeMenu);

document.addEventListener('keydown', (event) => {
    if (!open) return;

    if (event.key === 'Escape' || event.key === 'F1') {
        event.preventDefault();
        closeMenu();
    }
});
