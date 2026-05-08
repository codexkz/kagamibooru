"use strict";

const settings = require("./models/settings.js");

const SUPPORTED_LANGUAGES = {
    ja: "日本語",
    "zh-TW": "繁體中文",
    "zh-CN": "简体中文",
    en: "English",
    ko: "한국어",
};

const DEFAULT_LANGUAGE = "ja";

// All language files must be statically required for browserify bundling
const ALL_STRINGS = {
    ja: require("./i18n/ja.json"),
    "zh-TW": require("./i18n/zh-TW.json"),
    "zh-CN": require("./i18n/zh-CN.json"),
    en: require("./i18n/en.json"),
    ko: require("./i18n/ko.json"),
};

let _strings = {};
let _fallback = ALL_STRINGS["en"] || {};
let _currentLang = DEFAULT_LANGUAGE;

function t(key, fallback) {
    return _strings[key] || _fallback[key] || fallback || key;
}

function getCurrentLanguage() {
    return _currentLang;
}

function getSupportedLanguages() {
    return SUPPORTED_LANGUAGES;
}

function loadLanguage(lang) {
    if (!SUPPORTED_LANGUAGES[lang]) {
        lang = DEFAULT_LANGUAGE;
    }
    _currentLang = lang;
    _strings = ALL_STRINGS[lang] || {};
    _fallback = lang !== "en" ? (ALL_STRINGS["en"] || {}) : {};
}

function init() {
    const browsingSettings = settings.get();
    const lang = browsingSettings.language || DEFAULT_LANGUAGE;
    loadLanguage(lang);
}

init();

module.exports = { t, getCurrentLanguage, getSupportedLanguages, loadLanguage, init };
