"use strict";

const events = require("../events.js");
const views = require("../util/views.js");
const FileDropperControl = require("../controls/file_dropper_control.js");

const template = views.getTemplate("similarity-scans");
const rowTemplate = views.getTemplate("similarity-scan-row");

class SimilarityScansView extends events.EventTarget {
    constructor(ctx) {
        super();
        this._ctx = ctx;
        this._hostNode = document.getElementById("content-holder");

        views.replaceContent(this._hostNode, template(ctx));
        views.syncScrollPosition();

        this._initTabs();

        if (this._formNode) {
            views.decorateValidator(this._formNode);
            this._formNode.addEventListener("submit", (e) =>
                this._evtCreate(e)
            );
        }

        if (this._singleFormNode) {
            this._pendingFile = null;

            // "Search" next to the post-id field submits the form.
            this._singleFormNode.addEventListener("submit", (e) =>
                this._evtCreateByPostId(e)
            );

            const dropperNode = this._hostNode.querySelector(
                ".single-dropper"
            );
            if (dropperNode) {
                // allowUrls: false → no URL text box; drag/click/paste only.
                this._dropper = new FileDropperControl(dropperNode, {
                    allowUrls: false,
                    allowMultiple: false,
                });
                this._dropper.addEventListener("fileadd", (e) => {
                    const file = e.detail.files[0];
                    if (file) {
                        this._setPendingFile(file);
                    }
                });

                // Right-click "copy image" → paste (Discord-style). The
                // browser already holds the decoded bytes, so this works for
                // external images that CORS / bot-protection would block.
                this._pasteHandler = (e) => {
                    if (!document.body.contains(dropperNode)) {
                        return; // stale event after navigating away
                    }
                    const files = (e.clipboardData || {}).files || [];
                    if (files.length && files[0].type.startsWith("image/")) {
                        e.preventDefault();
                        this._setPendingFile(files[0]);
                    }
                };
                document.addEventListener("paste", this._pasteHandler);

                this._previewNode = this._hostNode.querySelector(
                    ".single-preview"
                );
                this._previewNode
                    .querySelector(".search-image")
                    .addEventListener("click", () => {
                        if (this._pendingFile) {
                            this._dispatchSingle({ file: this._pendingFile });
                        }
                    });
                this._previewNode
                    .querySelector(".clear-image")
                    .addEventListener("click", () => this._clearPendingFile());
            }
        }

        this._scanIdToRowNode = {};
        for (let scan of ctx.scans) {
            this._addScanRow(scan);
        }
    }

    _initTabs() {
        const nav = this._hostNode.querySelector("nav.similarity-tabs");
        if (!nav) {
            return; // no create privilege → no tabs
        }
        this._tabLinks = nav.querySelectorAll("li[data-tab]");
        this._tabPanes = this._hostNode.querySelectorAll(".tab-pane");
        for (let li of this._tabLinks) {
            li.querySelector("a").addEventListener("click", (e) => {
                e.preventDefault();
                this._activateTab(li.getAttribute("data-tab"));
            });
        }
        this._activateTab("full");
    }

    _activateTab(tab) {
        for (let li of this._tabLinks) {
            li.classList.toggle(
                "active",
                li.getAttribute("data-tab") === tab
            );
        }
        for (let pane of this._tabPanes) {
            pane.style.display =
                pane.getAttribute("data-tab") === tab ? "" : "none";
        }
    }

    get _formNode() {
        return this._hostNode.querySelector("form.similarity-new-scan");
    }

    get _singleFormNode() {
        return this._hostNode.querySelector("form.similarity-single-scan");
    }

    get _singleThreshold() {
        return parseFloat(
            this._singleFormNode.querySelector("[name=singleThreshold]").value
        );
    }

    _setPendingFile(file) {
        this._clearPendingFile();
        this._pendingFile = file;
        this._previewObjectUrl = URL.createObjectURL(file);
        const img = this._previewNode.querySelector("img.thumbnail");
        img.style.backgroundImage = `url('${this._previewObjectUrl}')`;
        img.src = this._previewObjectUrl;
        this._previewNode.style.display = "";
    }

    _clearPendingFile() {
        this._pendingFile = null;
        if (this._previewObjectUrl) {
            URL.revokeObjectURL(this._previewObjectUrl);
            this._previewObjectUrl = null;
        }
        if (this._previewNode) {
            this._previewNode.style.display = "none";
        }
    }

    _dispatchSingle(detail) {
        detail.threshold = this._singleThreshold;
        this.dispatchEvent(
            new CustomEvent("createSingle", { detail: detail })
        );
    }

    _evtCreateByPostId(e) {
        e.preventDefault();
        const postIdRaw = this._singleFormNode
            .querySelector("[name=queryPostId]")
            .value.trim();
        if (!postIdRaw) {
            this.showError(this._ctx.singleEmptyMsg);
            return;
        }
        this._dispatchSingle({ postId: parseInt(postIdRaw) });
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
