"use strict";

const router = require("../router.js");
const api = require("../api.js");
const uri = require("../util/uri.js");
const User = require("../models/user.js");
const UserList = require("../models/user_list.js");
const topNavigation = require("../models/top_navigation.js");
const AdminUsersView = require("../views/admin_users_view.js");
const EmptyView = require("../views/empty_view.js");
const i18n = require("../i18n.js");

class AdminUsersController {
    constructor(ctx) {
        if (!api.hasPrivilege("users:list")) {
            this._view = new EmptyView();
            this._view.showError(i18n.t("privileges.viewUsers"));
            return;
        }

        topNavigation.activate("admin-users");
        topNavigation.setTitle(i18n.t("adminUsers.title"));

        this._load();
    }

    showSuccess(message) {
        if (this._view) this._view.showSuccess(message);
    }

    _load() {
        UserList.search("", 0, 100).then(
            (response) => {
                this._view = new AdminUsersView({
                    users: response.results,
                });
                this._view.addEventListener("create", (e) =>
                    this._evtCreate(e)
                );
                this._view.addEventListener("rankChange", (e) =>
                    this._evtRankChange(e)
                );
                this._view.addEventListener("resetPassword", (e) =>
                    this._evtResetPassword(e)
                );
                this._view.addEventListener("deleteUser", (e) =>
                    this._evtDeleteUser(e)
                );
            },
            (error) => {
                this._view = new EmptyView();
                this._view.showError(error.message);
            }
        );
    }

    _evtCreate(e) {
        this._view.clearMessages();
        this._view.disableForm();
        const user = new User();
        user.name = e.detail.name;
        user.password = e.detail.password;
        user.email = e.detail.email;
        user.rank = e.detail.rank;
        user.save().then(
            () => {
                this._view.showSuccess(
                    i18n.t("adminUsers.userCreated").replace("{name}", e.detail.name)
                );
                this._view.enableForm();
                this._load();
            },
            (error) => {
                this._view.showError(error.message);
                this._view.enableForm();
            }
        );
    }

    _evtRankChange(e) {
        this._view.clearMessages();
        User.get(e.detail.userName).then((user) => {
            user.rank = e.detail.rank;
            return user.save();
        }).then(
            () => {
                this._view.showSuccess(
                    i18n.t("adminUsers.rankUpdated").replace("{name}", e.detail.userName)
                );
            },
            (error) => {
                this._view.showError(error.message);
                this._load();
            }
        );
    }

    _evtResetPassword(e) {
        this._view.clearMessages();
        User.get(e.detail.userName).then((user) => {
            user.password = e.detail.password;
            return user.save();
        }).then(
            () => {
                this._view.showSuccess(
                    i18n.t("adminUsers.passwordReset").replace("{name}", e.detail.userName)
                );
            },
            (error) => {
                this._view.showError(error.message);
            }
        );
    }

    _evtDeleteUser(e) {
        this._view.clearMessages();
        User.get(e.detail.userName).then((user) => {
            return user.delete();
        }).then(
            () => {
                this._view.showSuccess(
                    i18n.t("adminUsers.userDeleted").replace("{name}", e.detail.userName)
                );
                this._load();
            },
            (error) => {
                this._view.showError(error.message);
            }
        );
    }
}

module.exports = (router) => {
    router.enter(["admin", "users"], (ctx, next) => {
        ctx.controller = new AdminUsersController(ctx);
    });
};
