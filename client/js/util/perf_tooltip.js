"use strict";

/**
 * Styled tooltip utility — replaces browser native title tooltip.
 *
 * Currently UNUSED. Was wired up in posts_page_view.js and
 * post_content_control.js but removed because the styling didn't
 * fit the site's look.
 *
 * To re-enable:
 *   // posts_page_view.js
 *   const perfTooltip = require("../util/perf_tooltip.js");
 *   perfTooltip.attach(listItemNode);   // inside the listItemNodes loop
 *
 * attach(node) reads the first [title] attribute found inside node,
 * removes it (to suppress the native tooltip), and shows a styled
 * fixed-position tooltip on hover instead.
 */

let _tip = null;

function _createTip() {
    if (_tip) return _tip;
    const d = document.createElement("div");
    d.id = "perf-tooltip";
    d.style.cssText =
        "position:fixed;z-index:99999;background:#1a1a2e;color:#0f0;" +
        "font-family:monospace;font-size:11px;padding:8px 12px;" +
        "border-radius:4px;white-space:pre;user-select:text;" +
        "line-height:1.6;display:none;border:1px solid #333;" +
        "box-shadow:0 2px 8px rgba(0,0,0,0.5);max-width:450px;" +
        "pointer-events:none;";
    document.body.appendChild(d);
    _tip = d;
    return d;
}

function _posTip(e) {
    if (!_tip) return;
    let x = e.clientX + 15;
    let y = e.clientY + 15;
    if (x + 350 > window.innerWidth) x = e.clientX - 370;
    if (y + 200 > window.innerHeight) y = e.clientY - 210;
    _tip.style.left = x + "px";
    _tip.style.top = y + "px";
}

function _showTip(text, e) {
    const tip = _createTip();
    tip.textContent = text;
    tip.style.display = "block";
    _posTip(e);
}

function _hideTip() {
    if (_tip) _tip.style.display = "none";
}

/**
 * Attach tooltip to a specific element.
 * Replaces the native title tooltip with a styled one.
 */
function attach(node) {
    var titleEl = node.querySelector("[title]") || (node.title ? node : null);
    if (!titleEl) return;

    var text = titleEl.getAttribute("title") || "";
    if (!text) return;
    titleEl.removeAttribute("title");

    node.addEventListener("mouseover", function (e) {
        _showTip(text, e);
    });
    node.addEventListener("mousemove", function (e) {
        if (_tip && _tip.style.display !== "none") _posTip(e);
    });
    node.addEventListener("mouseout", function () {
        _hideTip();
    });
}

module.exports = { attach };
