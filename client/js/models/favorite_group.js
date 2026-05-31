"use strict";

const api = require("../api.js");
const uri = require("../util/uri.js");
const events = require("../events.js");

class FavoriteGroup extends events.EventTarget {
    constructor() {
        super();
        this._id = null;
        this._name = "";
        this._description = "";
        this._isDefault = false;
        this._postCount = 0;
        this._posts = [];
    }

    get id() {
        return this._id;
    }
    get name() {
        return this._name;
    }
    set name(value) {
        this._name = value;
    }
    get description() {
        return this._description;
    }
    set description(value) {
        this._description = value;
    }
    get isDefault() {
        return this._isDefault;
    }
    get postCount() {
        return this._postCount;
    }
    get posts() {
        return this._posts;
    }

    static fromResponse(response) {
        const ret = new FavoriteGroup();
        ret._updateFromResponse(response);
        return ret;
    }

    static get(id) {
        return api
            .get(uri.formatApiLink("favorite-group", id))
            .then((response) =>
                Promise.resolve(FavoriteGroup.fromResponse(response))
            );
    }

    static create(name, description) {
        return api
            .post(uri.formatApiLink("favorite-groups"), {
                name: name,
                description: description || "",
            })
            .then((response) =>
                Promise.resolve(FavoriteGroup.fromResponse(response))
            );
    }

    save() {
        return api
            .put(uri.formatApiLink("favorite-group", this._id), {
                name: this._name,
                description: this._description,
            })
            .then((response) => {
                this._updateFromResponse(response);
                return Promise.resolve();
            });
    }

    delete() {
        return api
            .delete(uri.formatApiLink("favorite-group", this._id))
            .then(() => {
                this.dispatchEvent(
                    new CustomEvent("delete", { detail: { group: this } })
                );
                return Promise.resolve();
            });
    }

    addPost(postId) {
        return api
            .post(
                uri.formatApiLink("favorite-group", this._id, "posts"),
                { postId: postId }
            )
            .then((response) => {
                this._updateFromResponse(response);
                return Promise.resolve();
            });
    }

    removePost(postId) {
        return api
            .delete(
                uri.formatApiLink(
                    "favorite-group",
                    this._id,
                    "post",
                    postId
                )
            )
            .then((response) => {
                this._updateFromResponse(response);
                return Promise.resolve();
            });
    }

    _updateFromResponse(response) {
        this._id = response.id;
        this._name = response.name;
        this._description = response.description || "";
        this._isDefault = response.isDefault;
        this._postCount = response.postCount;
        if (response.posts !== undefined) {
            this._posts = response.posts;
        }
    }
}

module.exports = FavoriteGroup;
