"use strict";

const events = require("../events.js");
const views = require("../util/views.js");
const i18n = require("../i18n.js");
const FavoriteGroupList = require("../models/favorite_group_list.js");
const FavoriteGroup = require("../models/favorite_group.js");

const template = views.getTemplate("user-favorite-groups");
const rowTemplate = views.getTemplate("favorite-group-row");

class UserFavoriteGroupsView extends events.EventTarget {
    constructor(ctx) {
        super();
        this._ctx = ctx;
        this._hostNode = ctx.hostNode;
        this._groups = [];
        views.replaceContent(this._hostNode, template(ctx));
        this._bindCreate();
        this._load();
    }

    get _listNode() {
        return this._hostNode.querySelector("ul.fav-group-list");
    }

    _load() {
        FavoriteGroupList.get().then(
            (response) => {
                this._groups = [...response.results];
                for (let group of this._groups) {
                    this._addRow(group);
                }
            },
            (error) => views.showError(this._hostNode, error.message)
        );
    }

    _addRow(group) {
        const row = rowTemplate({ group: group, t: i18n.t });
        this._bindRow(row, group);
        this._listNode.appendChild(row);
    }

    _bindRow(row, group) {
        const renameBtn = row.querySelector("a.rename");
        if (renameBtn) {
            renameBtn.addEventListener("click", (e) => this._evtEdit(e, group));
        }
        const deleteBtn = row.querySelector("a.delete");
        if (deleteBtn) {
            deleteBtn.addEventListener("click", (e) =>
                this._evtDelete(e, group)
            );
        }
    }

    _bindCreate() {
        const form = this._hostNode.querySelector("form.new-favorite-group");
        form.addEventListener("submit", (e) => this._evtCreate(e));
    }

    _evtCreate(e) {
        e.preventDefault();
        const form = this._hostNode.querySelector("form.new-favorite-group");
        const nameInput = form.querySelector("input[name=name]");
        const name = nameInput.value.trim();
        if (!name) {
            return;
        }
        FavoriteGroup.create(name).then(
            (group) => {
                this._groups.push(group);
                this._addRow(group);
                nameInput.value = "";
                views.showSuccess(this._hostNode, i18n.t("favGroup.created"));
            },
            (error) => views.showError(this._hostNode, error.message)
        );
    }

    _evtEdit(e, group) {
        e.preventDefault();
        const name = window.prompt(i18n.t("favGroup.renamePrompt"), group.name);
        if (name === null) {
            return;
        }
        const trimmed = name.trim();
        if (!trimmed || trimmed === group.name) {
            return;
        }
        group.name = trimmed;
        group.save().then(
            () => this._replaceRow(group),
            (error) => views.showError(this._hostNode, error.message)
        );
    }

    _replaceRow(group) {
        const oldRow = this._listNode.querySelector(
            `li[data-group-id='${group.id}']`
        );
        const newRow = rowTemplate({ group: group, t: i18n.t });
        this._bindRow(newRow, group);
        if (oldRow) {
            oldRow.parentNode.replaceChild(newRow, oldRow);
        }
    }

    _evtDelete(e, group) {
        e.preventDefault();
        if (!window.confirm(i18n.t("favGroup.deleteConfirm"))) {
            return;
        }
        group.delete().then(
            () => {
                const row = this._listNode.querySelector(
                    `li[data-group-id='${group.id}']`
                );
                if (row) {
                    row.parentNode.removeChild(row);
                }
                this._groups = this._groups.filter((g) => g.id !== group.id);
            },
            (error) => views.showError(this._hostNode, error.message)
        );
    }
}

module.exports = UserFavoriteGroupsView;
