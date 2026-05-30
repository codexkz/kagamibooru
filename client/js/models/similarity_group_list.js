"use strict";

const api = require("../api.js");
const uri = require("../util/uri.js");

class SimilarityGroupList {
    // Read-only for the MVP. Returns the raw serialized groups
    // (each group: { id, status, keepPostId, members: [{ postId,
    // distance, post: { id, thumbnailUrl } }] }).
    static getForScan(scanId, status) {
        const params = {};
        if (status) {
            params.status = status;
        }
        return api
            .get(uri.formatApiLink("similarity-scan", scanId, "groups", params))
            .then((response) => {
                return Promise.resolve(response.results);
            });
    }
}

module.exports = SimilarityGroupList;
