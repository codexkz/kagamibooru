"use strict";

const api = require("../api.js");
const i18n = require("../i18n.js");
const topNavigation = require("../models/top_navigation.js");
const SimilarityScan = require("../models/similarity_scan.js");
const SimilarityGroupList = require("../models/similarity_group_list.js");
const SimilarityScanView = require("../views/similarity_scan_view.js");
const EmptyView = require("../views/empty_view.js");

const PER_PAGE = 5;

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
        const offset = parseInt(ctx.parameters.offset) || 0;

        Promise.all([
            SimilarityScan.get(scanId),
            SimilarityGroupList.getForScan(scanId, offset, PER_PAGE),
        ]).then(
            ([scan, groupResponse]) => {
                this._view = new SimilarityScanView({
                    scan: scan,
                    groups: groupResponse.results,
                    offset: groupResponse.offset,
                    limit: groupResponse.limit,
                    total: groupResponse.total,
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
