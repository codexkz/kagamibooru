"use strict";

const events = require("../events.js");
const api = require("../api.js");
const i18n = require("../i18n.js");

class TopNavigationItem {
    constructor(accessKey, title, url, available, imageUrl) {
        this.accessKey = accessKey;
        this.title = title;
        this.url = url;
        this.available = available === undefined ? true : available;
        this.imageUrl = imageUrl === undefined ? null : imageUrl;
        this.key = null;
    }
}

class TopNavigation extends events.EventTarget {
    constructor() {
        super();
        this.activeItem = null;
        this._keyToItem = new Map();
        this._items = [];
    }

    getAll() {
        return this._items;
    }

    get(key) {
        if (!this._keyToItem.has(key)) {
            throw `An item with key ${key} does not exist.`;
        }
        return this._keyToItem.get(key);
    }

    add(key, item) {
        item.key = key;
        if (this._keyToItem.has(key)) {
            throw `An item with key ${key} was already added.`;
        }
        this._keyToItem.set(key, item);
        this._items.push(item);
    }

    activate(key) {
        this.activeItem = null;
        this.dispatchEvent(
            new CustomEvent("activate", {
                detail: {
                    key: key,
                    item: key ? this.get(key) : null,
                },
            })
        );
    }

    setTitle(title) {
        api.fetchConfig().then(() => {
            document.oldTitle = null;
            document.title = api.getName() + (title ? " – " + title : "");
        });
    }

    showAll() {
        for (let item of this._items) {
            item.available = true;
        }
    }

    show(key) {
        this.get(key).available = true;
    }

    hide(key) {
        this.get(key).available = false;
    }
}

function _makeTopNavigation() {
    const ret = new TopNavigation();
    ret.add("home", new TopNavigationItem("H", i18n.t("nav.home"), ""));
    ret.add("posts", new TopNavigationItem("P", i18n.t("nav.posts"), "posts"));
    ret.add("upload", new TopNavigationItem("U", i18n.t("nav.upload"), "upload"));
    ret.add("comments", new TopNavigationItem("C", i18n.t("nav.comments"), "comments"));
    ret.add("tags", new TopNavigationItem("T", i18n.t("nav.tags"), "tags"));
    ret.add("pools", new TopNavigationItem("O", i18n.t("nav.pools"), "pools"));
    ret.add("users", new TopNavigationItem("S", i18n.t("nav.users"), "users"));
    ret.add("account", new TopNavigationItem("A", i18n.t("nav.account"), "user/{me}"));
    ret.add("register", new TopNavigationItem("R", i18n.t("nav.register"), "register"));
    ret.add("login", new TopNavigationItem("L", i18n.t("nav.login"), "login"));
    ret.add("logout", new TopNavigationItem("O", i18n.t("nav.logout"), "logout"));
    ret.add("help", new TopNavigationItem("E", i18n.t("nav.help"), "help"));
    ret.add(
        "settings",
        new TopNavigationItem(null, "<i class='fa fa-cog'></i>", "settings")
    );
    return ret;
}

module.exports = _makeTopNavigation();
