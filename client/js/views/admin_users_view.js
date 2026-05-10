"use strict";

const events = require("../events.js");
const api = require("../api.js");
const views = require("../util/views.js");

const template = views.getTemplate("admin-users");

class AdminUsersView extends events.EventTarget {
    constructor(ctx) {
        super();
        this._hostNode = document.getElementById("content-holder");

        ctx.userNamePattern = api.getUserNameRegex();
        ctx.passwordPattern = api.getPasswordRegex();
        let ranks = {};
        for (let rankIdentifier of api.allRanks) {
            if (rankIdentifier === "anonymous" || rankIdentifier === "nobody") {
                continue;
            }
            ranks[rankIdentifier] = api.rankNames.get(rankIdentifier);
        }
        ctx.ranks = ranks;
        ctx.canCreate = api.hasPrivilege("users:create:any");
        ctx.canEdit = api.hasPrivilege("users:edit:any");
        ctx.canDelete = api.hasPrivilege("users:delete:any");
        ctx.currentUser = api.userName;

        views.replaceContent(this._hostNode, template(ctx));

        // Create user form
        if (this._createFormNode) {
            views.decorateValidator(this._createFormNode);
            this._createFormNode.addEventListener("submit", (e) =>
                this._evtCreateUser(e)
            );
        }

        // Rank change
        for (let select of this._hostNode.querySelectorAll(".rank-select")) {
            select.addEventListener("change", (e) =>
                this._evtRankChange(e)
            );
        }

        // Reset password
        for (let btn of this._hostNode.querySelectorAll(".btn-reset-password")) {
            btn.addEventListener("click", (e) =>
                this._evtResetPassword(e)
            );
        }

        // Delete user
        for (let btn of this._hostNode.querySelectorAll(".btn-delete-user")) {
            btn.addEventListener("click", (e) =>
                this._evtDeleteUser(e)
            );
        }
    }

    clearMessages() {
        views.clearMessages(this._hostNode);
    }

    showSuccess(message) {
        views.showSuccess(this._hostNode, message);
    }

    showError(message) {
        views.showError(this._hostNode, message);
    }

    enableForm() {
        if (this._createFormNode) {
            views.enableForm(this._createFormNode);
        }
    }

    disableForm() {
        if (this._createFormNode) {
            views.disableForm(this._createFormNode);
        }
    }

    _evtCreateUser(e) {
        e.preventDefault();
        this.dispatchEvent(
            new CustomEvent("create", {
                detail: {
                    name: this._createFormNode.querySelector("[name=name]").value,
                    password: this._createFormNode.querySelector("[name=password]").value,
                    email: this._createFormNode.querySelector("[name=email]").value,
                    rank: this._createFormNode.querySelector("[name=rank]").value,
                },
            })
        );
    }

    _evtRankChange(e) {
        const userName = e.target.getAttribute("data-user");
        const rank = e.target.value;
        this.dispatchEvent(
            new CustomEvent("rankChange", {
                detail: { userName: userName, rank: rank },
            })
        );
    }

    _evtResetPassword(e) {
        e.preventDefault();
        const userName = e.target.getAttribute("data-user");
        const newPassword = window.prompt(
            "Enter new password for " + userName + ":"
        );
        if (!newPassword) return;
        this.dispatchEvent(
            new CustomEvent("resetPassword", {
                detail: { userName: userName, password: newPassword },
            })
        );
    }

    _evtDeleteUser(e) {
        e.preventDefault();
        const userName = e.target.getAttribute("data-user");
        if (!window.confirm("Delete user \"" + userName + "\"? This cannot be undone.")) {
            return;
        }
        this.dispatchEvent(
            new CustomEvent("deleteUser", {
                detail: { userName: userName },
            })
        );
    }

    get _createFormNode() {
        return this._hostNode.querySelector("#create-user-form");
    }
}

module.exports = AdminUsersView;
