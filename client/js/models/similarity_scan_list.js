"use strict";

const api = require("../api.js");
const uri = require("../util/uri.js");
const AbstractList = require("./abstract_list.js");
const SimilarityScan = require("./similarity_scan.js");

class SimilarityScanList extends AbstractList {
    static get() {
        return api
            .get(uri.formatApiLink("similarity-scans"))
            .then((response) => {
                return Promise.resolve(
                    Object.assign({}, response, {
                        results: SimilarityScanList.fromResponse(
                            response.results
                        ),
                    })
                );
            });
    }
}

SimilarityScanList._itemClass = SimilarityScan;
SimilarityScanList._itemName = "scan";

module.exports = SimilarityScanList;
