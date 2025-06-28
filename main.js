
const baseURL = 'https://dev.tinysquares.io/';
const workerURL = 'https://quiet-mouse-8001.flaxen-huskier-06.workers.dev/';

async function loadGallery() {
    try {
        const res = await fetch(workerURL);
        const filenames = await res.json();

        const gallery = document.getElementById('gallery');
        filenames.forEach(name => {
            const ext = name.split('.').pop().toLowerCase();

            if (['webp', 'jpg', 'jpeg', 'png'].includes(ext)) {
                const img = document.createElement('img');
                img.src = baseURL + name;
                img.alt = name;
                img.loading = 'lazy';
                gallery.appendChild(img);
            } else if (ext === 'mp4') {
                const video = document.createElement('video');
                video.src = baseURL + name;
                video.muted = true;
                video.loop = true;
                video.autoplay = true;
                video.playsInline = true;
                video.style.width = "100%";
                video.style.borderRadius = "6px";
                gallery.appendChild(video);
            }
        });
    } catch (err) {
        console.error('Error loading images:', err);
    }
}

window.addEventListener('DOMContentLoaded', () => {
    document.addEventListener('contextmenu', e => e.preventDefault());
    loadGallery();
});
