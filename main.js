
const baseURL = 'https://dev.tinysquares.io/';
const workerURL = 'https://quiet-mouse-8001.flaxen-huskier-06.workers.dev/';

const images = [];
let currentIndex = 0;

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
                img.dataset.index = images.length;
                img.addEventListener('click', () => openLightbox(parseInt(img.dataset.index)));
                gallery.appendChild(img);
                images.push(img);
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

function openLightbox(index) {
    currentIndex = index;
    const lightbox = document.getElementById('lightbox');
    const img = document.getElementById('lightbox-img');
    img.src = images[currentIndex].src;
    lightbox.classList.remove('hidden');
}

function showNext() {
    currentIndex = (currentIndex + 1) % images.length;
    document.getElementById('lightbox-img').src = images[currentIndex].src;
}

function showPrev() {
    currentIndex = (currentIndex - 1 + images.length) % images.length;
    document.getElementById('lightbox-img').src = images[currentIndex].src;
}

function setupLightbox() {
    document.getElementById('next').addEventListener('click', showNext);
    document.getElementById('prev').addEventListener('click', showPrev);
    document.getElementById('lightbox').addEventListener('click', e => {
        if (e.target.id === 'lightbox') {
            e.currentTarget.classList.add('hidden');
        }
    });
    window.addEventListener('keydown', e => {
        if (document.getElementById('lightbox').classList.contains('hidden')) return;
        if (e.key === 'ArrowRight') showNext();
        if (e.key === 'ArrowLeft') showPrev();
        if (e.key === 'Escape') document.getElementById('lightbox').classList.add('hidden');
    });
}

function setupThemeToggle() {
    const btn = document.getElementById('theme-toggle');
    const dark = localStorage.getItem('darkMode') === 'true';
    if (dark) {
        document.body.classList.add('dark');
        btn.textContent = '☀️';
    }
    btn.addEventListener('click', () => {
        document.body.classList.toggle('dark');
        const isDark = document.body.classList.contains('dark');
        btn.textContent = isDark ? '☀️' : '🌙';
        localStorage.setItem('darkMode', isDark);
    });
}

window.addEventListener('DOMContentLoaded', () => {
    document.addEventListener('contextmenu', e => e.preventDefault());
    setupThemeToggle();
    setupLightbox();
    loadGallery();
});
