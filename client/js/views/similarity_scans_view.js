"use strict";

const events = require("../events.js");
const views = require("../util/views.js");

const template = views.getTemplate("similarity-scans");
const rowTemplate = views.getTemplate("similarity-scan-row");

class SimilarityScansView extends events.EventTarget {
    constructor(ctx) {
        super();
        this._ctx = ctx;
        this._hostNode = document.getElementById("content-holder");

        views.replaceContent(this._hostNode, template(ctx));
        views.syncScrollPosition();

        if (this._formNode) {
            views.decorateValidator(this._formNode);
            this._formNode.addEventListener("submit", (e) =>
                this._evtCreate(e)
            );
        }

        this._scanIdToRowNode = {};
        for (let scan of ctx.scans) {
            this._addScanRow(scan);
        }
    }

    get _formNode() {
        return this._hostNode.querySelector("form.similarity-new-scan");
    }

    get _tableBodyNode() {
        return this._hostNode.querySelector("table.scans tbody");
    }

    get _thresholdFieldNode() {
        return this._hostNode.querySelector("[name=threshold]");
    }

    clearMessages() {
        views.clearMessages(this._hostNode);
    }

    showSuccess(message) {
        views.showSuccess(this._hostNode, message);
    }

    showError(message) {
        views.showError(this._hostNode, message);
    }

    enableForm() {
        if (this._formNode) {
            views.enableForm(this._formNode);
        }
    }

    disableForm() {
        if (this._formNode) {
            views.disableForm(this._formNode);
        }
    }

    addScan(scan) {
        this._addScanRow(scan, true);
    }

    updateScanRow(scan) {
        const oldRow = this._scanIdToRowNode[scan.id];
        if (!oldRow) {
            return;
        }
        const newRow = this._renderRow(scan);
        oldRow.parentNode.replaceChild(newRow, oldRow);
        this._scanIdToRowNode[scan.id] = newRow;
    }

    removeScanRow(scan) {
        const row = this._scanIdToRowNode[scan.id];
        if (row) {
            row.parentNode.removeChild(row);
            delete this._scanIdToRowNode[scan.id];
        }
    }

    _renderRow(scan) {
        const rowNode = rowTemplate(
            Object.assign({}, this._ctx, { scan: scan })
        );
        const deleteLink = rowNode.querySelector("a.delete");
        if (deleteLink) {
            deleteLink.addEventListener("click", (e) =>
                this._evtDelete(e, scan)
            );
        }
        return rowNode;
    }

    _addScanRow(scan, prepend) {
        const rowNode = this._renderRow(scan);
        this._scanIdToRowNode[scan.id] = rowNode;
        if (prepend && this._tableBodyNode.firstChild) {
            this._tableBodyNode.insertBefore(
                rowNode,
                this._tableBodyNode.firstChild
            );
        } else {
            this._tableBodyNode.appendChild(rowNode);
        }
    }

    _evtCreate(e) {
        e.preventDefault();
        const threshold = parseFloat(this._thresholdFieldNode.value);
        this.dispatchEvent(
            new CustomEvent("create", { detail: { threshold: threshold } })
        );
    }

    _evtDelete(e, scan) {
        e.preventDefault();
        this.dispatchEvent(
            new CustomEvent("delete", { detail: { scan: scan } })
        );
    }
}

module.exports = SimilarityScansView;
