"use strict";

const api = require("../api.js");
const i18n = require("../i18n.js");
const topNavigation = require("../models/top_navigation.js");
const SimilarityScan = require("../models/similarity_scan.js");
const SimilarityGroupList = require("../models/similarity_group_list.js");
const SimilarityScanView = require("../views/similarity_scan_view.js");
const EmptyView = require("../views/empty_view.js");

class SimilarityScanController {
    constructor(ctx) {
        if (!api.hasPrivilege("posts:similarity:list")) {
            this._view = new EmptyView();
            this._view.showError(i18n.t("similarity.noPrivilege"));
            return;
        }

        topNavigation.activate("similarity");
        topNavigation.setTitle(i18n.t("similarity.title"));

        const scanId = ctx.parameters.id;

        Promise.all([
            SimilarityScan.get(scanId),
            SimilarityGroupList.getForScan(scanId),
        ]).then(
            ([scan, groups]) => {
                this._view = new SimilarityScanView({
                    scan: scan,
                    groups: groups,
                });
            },
            (error) => {
                this._view = new EmptyView();
                this._view.showError(error.message);
            }
        );
    }
}

module.exports = (router) => {
    router.enter(["similarity-scan", ":id"], (ctx, next) => {
        ctx.controller = new SimilarityScanController(ctx);
    });
};
