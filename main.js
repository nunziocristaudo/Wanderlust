
const baseURL = 'https://dev.tinysquares.io/';
const workerURL = 'https://quiet-mouse-8001.flaxen-huskier-06.workers.dev/';

async function loadGallery() {
    try {
        const res = await fetch(workerURL);
        const filenames = await res.json();

        const gallery = document.getElementById('gallery');
        filenames.forEach(name => {
            const img = document.createElement('img');
            img.src = baseURL + name;
            img.alt = name;
            img.loading = 'lazy';
            gallery.appendChild(img);
        });
    } catch (err) {
        console.error('Error loading images:', err);
    }
}

window.addEventListener('DOMContentLoaded', loadGallery);
