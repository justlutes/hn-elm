import { CustomElement } from './custom_element';

class CustomElementTest extends CustomElement {
  private _state: boolean;

  constructor() {
    super();

    this._state = false;
    this._toggle = this._toggle.bind(this);
  }

  connectedCallback() {
    this.innerHTML = `State: ${this._state}`;
    this.addEventListener('click', this._toggle);
  }

  private _toggle() {
    this._state = !this._state;
    this.innerHTML = `State: ${this._state}`;
  }
}

export default customElements.define('custom-element-test', CustomElementTest);
