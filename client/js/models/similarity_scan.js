"use strict";

const api = require("../api.js");
const uri = require("../util/uri.js");
const events = require("../events.js");

class SimilarityScan extends events.EventTarget {
    constructor() {
        super();
        this._id = null;
        this._creationTime = null;
        this._finishTime = null;
        this._status = "running";
        this._threshold = 0.45;
        this._processedCount = 0;
        this._totalCount = 0;
        this._groupCount = 0;
        this._error = null;
    }

    get id() {
        return this._id;
    }

    get creationTime() {
        return this._creationTime;
    }

    get finishTime() {
        return this._finishTime;
    }

    get status() {
        return this._status;
    }

    get threshold() {
        return this._threshold;
    }

    get processedCount() {
        return this._processedCount;
    }

    get totalCount() {
        return this._totalCount;
    }

    get groupCount() {
        return this._groupCount;
    }

    get error() {
        return this._error;
    }

    get isRunning() {
        return this._status === "running";
    }

    get isDone() {
        return this._status === "done";
    }

    get isFailed() {
        return this._status === "failed";
    }

    get progress() {
        if (!this._totalCount) {
            return 0;
        }
        return Math.floor((this._processedCount / this._totalCount) * 100);
    }

    static fromResponse(response) {
        const ret = new SimilarityScan();
        ret._updateFromResponse(response);
        return ret;
    }

    static get(id) {
        // A throwaway parameter is appended to bypass the api GET cache so
        // that progress polling actually re-hits the server. The backend
        // ignores unknown query parameters.
        return api
            .get(uri.formatApiLink("similarity-scan", id, { t: Date.now() }))
            .then((response) => {
                return Promise.resolve(SimilarityScan.fromResponse(response));
            });
    }

    static create(threshold) {
        return api
            .post(uri.formatApiLink("similarity-scans"), {
                threshold: threshold,
            })
            .then((response) => {
                return Promise.resolve(SimilarityScan.fromResponse(response));
            });
    }

    static createSingleFromPost(threshold, postId) {
        return api
            .post(uri.formatApiLink("similarity-scans"), {
                kind: "single",
                threshold: threshold,
                queryPostId: postId,
            })
            .then((response) =>
                Promise.resolve(SimilarityScan.fromResponse(response))
            );
    }

    static createSingleFromUrl(threshold, url) {
        return api
            .post(uri.formatApiLink("similarity-scans"), {
                kind: "single",
                threshold: threshold,
                contentUrl: url,
            })
            .then((response) =>
                Promise.resolve(SimilarityScan.fromResponse(response))
            );
    }

    static createSingleFromUpload(threshold, file) {
        return api
            .post(
                uri.formatApiLink("similarity-scans"),
                { kind: "single", threshold: threshold },
                { content: file }
            )
            .then((response) =>
                Promise.resolve(SimilarityScan.fromResponse(response))
            );
    }

    refresh() {
        return SimilarityScan.get(this._id).then((scan) => {
            this._updateFromResponse({
                id: scan._id,
                creationTime: scan._creationTime,
                finishTime: scan._finishTime,
                status: scan._status,
                threshold: scan._threshold,
                processedCount: scan._processedCount,
                totalCount: scan._totalCount,
                groupCount: scan._groupCount,
                error: scan._error,
            });
            this.dispatchEvent(
                new CustomEvent("change", { detail: { scan: this } })
            );
            return Promise.resolve(this);
        });
    }

    delete() {
        return api
            .delete(uri.formatApiLink("similarity-scan", this._id))
            .then((response) => {
                this.dispatchEvent(
                    new CustomEvent("delete", { detail: { scan: this } })
                );
                return Promise.resolve();
            });
    }

    get kind() {
        return this._kind;
    }

    get queryLabel() {
        return this._queryLabel;
    }

    _updateFromResponse(response) {
        this._id = response.id;
        this._kind = response.kind;
        this._queryLabel = response.queryLabel;
        this._creationTime = response.creationTime;
        this._finishTime = response.finishTime;
        this._status = response.status;
        this._threshold = response.threshold;
        this._processedCount = response.processedCount;
        this._totalCount = response.totalCount;
        this._groupCount = response.groupCount;
        this._error = response.error;
    }
}

module.exports = SimilarityScan;
