const translations = {};
let currentLang = localStorage.getItem('language') || (navigator.language.startsWith('de') ? 'de' : 'en');

async function loadLanguage(lang) {
    if (!translations[lang]) {
        try {
            const response = await fetch(`public/locales/${lang}.json`);
            translations[lang] = await response.json();
        } catch (error) {
            console.error(`Could not load language ${lang}:`, error);
            if (lang !== 'en') return loadLanguage('en');
            return;
        }
    }
    
    currentLang = lang;
    localStorage.setItem('language', lang);
    document.documentElement.lang = lang;
    applyTranslations();
    updateActiveLanguageUI();
}

function applyTranslations() {
    const data = translations[currentLang];
    if (!data) return;

    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        const value = getNestedValue(data, key);
        if (value) {
            if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
                el.placeholder = value;
            } else {
                el.innerHTML = value;
            }
        }
    });
}

function getNestedValue(obj, path) {
    return path.split('.').reduce((prev, curr) => {
        return prev ? prev[curr] : null;
    }, obj);
}

function updateActiveLanguageUI() {
    document.querySelectorAll('[data-lang-switch]').forEach(el => {
        if (el.getAttribute('data-lang-switch') === currentLang) {
            el.classList.add('btn-active', 'btn-primary');
            el.classList.remove('btn-ghost');
        } else {
            el.classList.remove('btn-active', 'btn-primary');
            el.classList.add('btn-ghost');
        }
    });
}

document.addEventListener('DOMContentLoaded', () => {
    loadLanguage(currentLang);
    
    document.querySelectorAll('[data-lang-switch]').forEach(el => {
        el.addEventListener('click', (e) => {
            e.preventDefault();
            const lang = el.getAttribute('data-lang-switch');
            loadLanguage(lang);
        });
    });
});
