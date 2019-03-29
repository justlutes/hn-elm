"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const custom_element_1 = require("../../../js/components/custom_element");
require("./style.scss");
const createSvg_1 = require("../../../js/lib/createSvg");
class LoadingSpinner extends custom_element_1.CustomElement {
    constructor() {
        super();
        this._color = this.color;
        delete this.color;
        this._size = this.size;
        delete this.size;
    }
    connectedCallback() {
        const svgEl = createSvg_1.default('loading', 'loading');
        const wrapper = document.createElement('div');
        wrapper.className = 'hn-loading-spinner-wrapper';
        wrapper.appendChild(svgEl);
        this.appendChild(wrapper);
    }
    set color(color) {
        if (this._color === color)
            return;
        this._color = color;
        this.style.setProperty('--hn-loading-spinner-color', this._color);
    }
    set size(size) {
        if (this._size === size)
            return;
        this._size = size;
        this.style.setProperty('--hn-loading-spinner-size', `${this._size}px`);
    }
}
exports.default = customElements.define('hn-loading-spinner', LoadingSpinner);
