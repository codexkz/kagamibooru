"use strict";

const events = require("../events.js");
const views = require("../util/views.js");

const template = views.getTemplate("similarity-scan");

class SimilarityScanView extends events.EventTarget {
    constructor(ctx) {
        super();
        this._ctx = ctx;
        this._hostNode = document.getElementById("content-holder");

        views.replaceContent(this._hostNode, template(ctx));
        views.syncScrollPosition();
    }

    showError(message) {
        views.showError(this._hostNode, message);
    }
}

module.exports = SimilarityScanView;
