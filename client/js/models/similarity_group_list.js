"use strict";

const api = require("../api.js");
const uri = require("../util/uri.js");

class SimilarityGroupList {
    // Read-only for the MVP. Returns the raw paginated response:
    // { offset, limit, total, results: [{ id, status, keepPostId,
    // members: [{ postId, distance, post: { id, thumbnailUrl } }] }] }.
    static getForScan(scanId, offset, limit, status) {
        const params = { offset: offset, limit: limit };
        if (status) {
            params.status = status;
        }
        return api
            .get(uri.formatApiLink("similarity-scan", scanId, "groups", params))
            .then((response) => {
                return Promise.resolve(response);
            });
    }
}

module.exports = SimilarityGroupList;
