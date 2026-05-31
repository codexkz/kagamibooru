"use strict";

const api = require("../api.js");
const router = require("../router.js");
const uri = require("../util/uri.js");
const i18n = require("../i18n.js");
const topNavigation = require("../models/top_navigation.js");
const SimilarityScanList = require("../models/similarity_scan_list.js");
const SimilarityScan = require("../models/similarity_scan.js");
const SimilarityScansView = require("../views/similarity_scans_view.js");
const EmptyView = require("../views/empty_view.js");

const POLL_INTERVAL_MS = 3000;

class SimilarityScansController {
    constructor() {
        if (!api.hasPrivilege("posts:similarity:list")) {
            this._view = new EmptyView();
            this._view.showError(i18n.t("similarity.noPrivilege"));
            return;
        }

        topNavigation.activate("similarity");
        topNavigation.setTitle(i18n.t("similarity.title"));

        this._pollTimer = null;

        SimilarityScanList.get().then(
            (response) => {
                this._scans = response.results;
                this._view = new SimilarityScansView({
                    scans: this._scans,
                    canCreate: api.hasPrivilege("posts:similarity:create"),
                    canDelete: api.hasPrivilege("posts:similarity:delete"),
                    singleEmptyMsg: i18n.t("similarity.singleEmpty"),
                });
                this._view.addEventListener("create", (e) =>
                    this._evtCreate(e)
                );
                this._view.addEventListener("delete", (e) =>
                    this._evtDelete(e)
                );
                this._view.addEventListener("createSingle", (e) =>
                    this._evtCreateSingle(e)
                );
                this._startPollingIfNeeded();
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
        SimilarityScan.create(e.detail.threshold).then(
            (scan) => {
                this._view.enableForm();
                this._view.showSuccess(i18n.t("similarity.scanStarted"));
                this._scans.add(scan);
                this._view.addScan(scan);
                this._startPollingIfNeeded();
            },
            (error) => {
                this._view.enableForm();
                this._view.showError(error.message);
            }
        );
    }

    _evtCreateSingle(e) {
        this._view.clearMessages();
        this._view.disableForm();
        const d = e.detail;
        let promise;
        if (d.postId) {
            promise = SimilarityScan.createSingleFromPost(
                d.threshold,
                d.postId
            );
        } else if (d.file) {
            promise = SimilarityScan.createSingleFromUpload(
                d.threshold,
                d.file
            );
        } else {
            promise = SimilarityScan.createSingleFromUrl(d.threshold, d.url);
        }
        promise.then(
            (scan) => {
                // Single scans complete synchronously; jump straight to the
                // result page.
                router.show(
                    uri.formatClientLink("similarity-scan", scan.id)
                );
            },
            (error) => {
                this._view.enableForm();
                this._view.showError(error.message);
            }
        );
    }

    _evtDelete(e) {
        const scan = e.detail.scan;
        if (!window.confirm(i18n.t("similarity.confirmDelete"))) {
            return;
        }
        scan.delete().then(
            () => {
                this._scans.remove(scan);
                this._view.removeScanRow(scan);
            },
            (error) => {
                this._view.showError(error.message);
            }
        );
    }

    _hasRunningScan() {
        for (let scan of this._scans) {
            if (scan.isRunning) {
                return true;
            }
        }
        return false;
    }

    _startPollingIfNeeded() {
        if (this._pollTimer || !this._hasRunningScan()) {
            return;
        }
        this._pollTimer = window.setInterval(
            () => this._poll(),
            POLL_INTERVAL_MS
        );
    }

    _stopPolling() {
        if (this._pollTimer) {
            window.clearInterval(this._pollTimer);
            this._pollTimer = null;
        }
    }

    _poll() {
        const running = [];
        for (let scan of this._scans) {
            if (scan.isRunning) {
                running.push(scan);
            }
        }
        if (!running.length) {
            this._stopPolling();
            return;
        }
        for (let scan of running) {
            scan.refresh().then(
                () => this._view.updateScanRow(scan),
                () => {} // ignore transient poll errors
            );
        }
    }
}

module.exports = (router) => {
    router.enter(["similarity-scans"], (ctx, next) => {
        ctx.controller = new SimilarityScansController(ctx);
    });
};
