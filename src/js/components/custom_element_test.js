"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const custom_element_1 = require("./custom_element");
class CustomElementTest extends custom_element_1.CustomElement {
    constructor() {
        super();
        this._state = false;
        this._toggle = this._toggle.bind(this);
    }
    connectedCallback() {
        this.innerHTML = `State: ${this._state}`;
        this.addEventListener('click', this._toggle);
    }
    _toggle() {
        this._state = !this._state;
        this.innerHTML = `State: ${this._state}`;
    }
}
exports.default = customElements.define('custom-element-test', CustomElementTest);
