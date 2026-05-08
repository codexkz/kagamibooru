"use strict";

const router = require("../router.js");
const api = require("../api.js");
const misc = require("../util/misc.js");
const uri = require("../util/uri.js");
const PoolCategoryList = require("../models/pool_category_list.js");
const PoolCreateView = require("../views/pool_create_view.js");
const EmptyView = require("../views/empty_view.js");
const i18n = require("../i18n.js");

class PoolCreateController {
    constructor(ctx) {
        if (!api.hasPrivilege("pools:create")) {
            this._view = new EmptyView();
            this._view.showError(i18n.t("privileges.createPools"));
            return;
        }

        PoolCategoryList.get().then(
            (poolCategoriesResponse) => {
                const categories = {};
                for (let category of poolCategoriesResponse.results) {
                    categories[category.name] = category.name;
                }

                this._view = new PoolCreateView({
                    canCreate: api.hasPrivilege("pools:create"),
                    categories: categories,
                    escapeTagName: uri.escapeTagName,
                });

                this._view.addEventListener("submit", (e) =>
                    this._evtCreate(e)
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
        api.post(uri.formatApiLink("pool"), e.detail).then(
            () => {
                this._view.clearMessages();
                misc.disableExitConfirmation();
                const ctx = router.show(uri.formatClientLink("pools"));
                ctx.controller.showSuccess(i18n.t("pool.created"));
            },
            (error) => {
                this._view.showError(error.message);
                this._view.enableForm();
            }
        );
    }
}

module.exports = (router) => {
    router.enter(["pool", "create"], (ctx, next) => {
        ctx.controller = new PoolCreateController(ctx, "create");
    });
};
