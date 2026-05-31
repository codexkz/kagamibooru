"use strict";

const events = require("../events.js");
const views = require("../util/views.js");
const i18n = require("../i18n.js");
const FavoriteGroupList = require("../models/favorite_group_list.js");
const FavoriteGroup = require("../models/favorite_group.js");

const template = views.getTemplate("favorite-group-picker");

// A modal that lets the user toggle a post's membership across all of their
// favorite groups, and create / rename / delete groups inline. Keeps the same
// row layout as the account "favorite groups" tab for visual consistency.
class FavoriteGroupPickerControl extends events.EventTarget {
    constructor(post) {
        super();
        this._post = post;
        this._groups = [];
        this._overlayNode = null;
    }

    open() {
        FavoriteGroupList.get().then(
            (response) => {
                this._groups = [...response.results];
                this._render();
            },
            (error) => window.alert(error.message)
        );
    }

    _memberOf() {
        const set = new Set();
        for (let group of this._groups) {
            if (
                this._post.favoriteGroupIds &&
                this._post.favoriteGroupIds.indexOf(group.id) !== -1
            ) {
                set.add(group.id);
            }
        }
        return set;
    }

    _render() {
        this._overlayNode = template({
            groups: this._groups,
            memberOf: this._memberOf(),
            t: i18n.t,
        });
        document.body.appendChild(this._overlayNode);

        this._overlayNode
            .querySelector(".close")
            .addEventListener("click", () => this.close());
        // Click outside the dialog closes it.
        this._overlayNode.addEventListener("click", (e) => {
            if (e.target === this._overlayNode) {
                this.close();
            }
        });

        for (let li of this._overlayNode.querySelectorAll("li[data-group-id]")) {
            this._bindRow(li);
        }

        this._overlayNode
            .querySelector("form.create-row")
            .addEventListener("submit", (e) => this._evtCreate(e));
    }

    _bindRow(li) {
        const groupId = parseInt(li.getAttribute("data-group-id"));
        const checkbox = li.querySelector("input[type=checkbox]");
        if (checkbox) {
            checkbox.addEventListener("change", () =>
                this._evtToggle(groupId, checkbox)
            );
        }
        const rename = li.querySelector("a.rename");
        if (rename) {
            rename.addEventListener("click", (e) => this._evtEdit(e, groupId));
        }
        const del = li.querySelector("a.delete");
        if (del) {
            del.addEventListener("click", (e) => this._evtDelete(e, groupId));
        }
    }

    _evtEdit(e, groupId) {
        e.preventDefault();
        const group = this._group(groupId);
        if (!group) {
            return;
        }
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
            (error) => this._showError(error.message)
        );
    }

    _replaceRow(group) {
        const li = this._overlayNode.querySelector(
            `li[data-group-id='${group.id}']`
        );
        if (!li) {
            return;
        }
        const newLi = this._buildRow(group, this._rowChecked(li));
        li.parentNode.replaceChild(newLi, li);
        this._bindRow(newLi);
    }

    _rowChecked(li) {
        const cb = li.querySelector("input[type=checkbox]");
        return cb ? cb.checked : false;
    }

    _evtDelete(e, groupId) {
        e.preventDefault();
        const group = this._group(groupId);
        if (!group) {
            return;
        }
        if (!window.confirm(i18n.t("favGroup.deleteConfirm"))) {
            return;
        }
        group.delete().then(
            () => {
                const li = this._overlayNode.querySelector(
                    `li[data-group-id='${groupId}']`
                );
                if (li) {
                    li.parentNode.removeChild(li);
                }
                this._groups = this._groups.filter((g) => g.id !== groupId);
                this.dispatchEvent(
                    new CustomEvent("change", {
                        detail: { post: this._post },
                    })
                );
            },
            (error) => this._showError(error.message)
        );
    }

    _group(groupId) {
        return this._groups.find((g) => g.id === groupId);
    }

    _evtToggle(groupId, checkbox) {
        const group = this._group(groupId);
        if (!group) {
            return;
        }
        checkbox.disabled = true;
        const action = checkbox.checked
            ? group.addPost(this._post.id)
            : group.removePost(this._post.id);
        action.then(
            () => {
                checkbox.disabled = false;
                this._updateCount(groupId, group.postCount);
                this.dispatchEvent(
                    new CustomEvent("change", {
                        detail: { post: this._post },
                    })
                );
            },
            (error) => {
                checkbox.disabled = false;
                checkbox.checked = !checkbox.checked; // revert
                this._showError(error.message);
            }
        );
    }

    _updateCount(groupId, count) {
        const node = this._overlayNode.querySelector(
            `li[data-group-id='${groupId}'] .count`
        );
        if (node) {
            node.textContent = `(${count})`;
        }
    }

    _evtCreate(e) {
        e.preventDefault();
        const nameInput = this._overlayNode.querySelector(".new-group-name");
        const name = nameInput.value.trim();
        if (!name) {
            return;
        }
        const button = this._overlayNode.querySelector(".create-group");
        button.disabled = true;
        FavoriteGroup.create(name).then(
            (group) => {
                button.disabled = false;
                nameInput.value = "";
                this._groups.push(group);
                const li = this._buildRow(group, false);
                this._overlayNode
                    .querySelector("ul.fav-group-list")
                    .appendChild(li);
                this._bindRow(li);
            },
            (error) => {
                button.disabled = false;
                this._showError(error.message);
            }
        );
    }

    // Build a row that matches the server-rendered template structure so that
    // dynamically-added rows look identical to the initial render.
    _buildRow(group, checked) {
        const li = document.createElement("li");
        li.setAttribute("data-group-id", group.id);

        const label = document.createElement("label");
        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.checked = !!checked;

        const info = document.createElement("span");
        info.className = "info";
        const line = document.createElement("span");
        line.className = "line";
        const name = document.createElement("span");
        name.className = "name";
        name.textContent = group.name;
        line.appendChild(name);
        if (group.isDefault) {
            const badge = document.createElement("span");
            badge.className = "default-badge";
            badge.textContent = i18n.t("favGroup.defaultBadge");
            line.appendChild(badge);
        }
        const count = document.createElement("span");
        count.className = "count";
        count.textContent = `(${group.postCount})`;
        line.appendChild(count);
        info.appendChild(line);
        label.appendChild(checkbox);
        label.appendChild(info);
        li.appendChild(label);

        const actions = document.createElement("span");
        actions.className = "row-actions";
        const rename = document.createElement("a");
        rename.href = "";
        rename.className = "rename";
        rename.title = i18n.t("favGroup.rename");
        rename.innerHTML = "<i class='fa fa-pencil'></i>";
        actions.appendChild(rename);
        if (!group.isDefault) {
            const del = document.createElement("a");
            del.href = "";
            del.className = "delete";
            del.title = i18n.t("favGroup.delete");
            del.innerHTML = "<i class='fa fa-trash-o'></i>";
            actions.appendChild(del);
        }
        li.appendChild(actions);
        return li;
    }

    _showError(message) {
        const node = this._overlayNode.querySelector(".messages");
        if (node) {
            node.textContent = message;
        }
    }

    close() {
        if (this._overlayNode && this._overlayNode.parentNode) {
            this._overlayNode.parentNode.removeChild(this._overlayNode);
        }
        this._overlayNode = null;
        this.dispatchEvent(new CustomEvent("close"));
    }
}

module.exports = FavoriteGroupPickerControl;
