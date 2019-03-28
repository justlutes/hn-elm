import { CustomElement } from '../../js/components/custom_element';
import './style.scss';
import createSvg from '../../js/lib/createSvg';

class LoadingSpinner extends CustomElement {
  private _color: string;
  private _size: string;

  constructor() {
    super();

    this._color = this.color;
    delete this.color;

    this._size = this.size;
    delete this.size;
  }

  connectedCallback() {
    const svgEl = createSvg('loading', 'loading');
    const wrapper = document.createElement('div');
    wrapper.className = 'hn-loading-spinner-wrapper';
    wrapper.appendChild(svgEl);
    this.appendChild(wrapper);
  }

  set color(color: string) {
    if (this._color === color) return;
    this._color = color;
    this.style.setProperty('--hn-loading-spinner-color', this._color);
  }

  set size(size: string) {
    if (this._size === size) return;
    this._size = size;
    this.style.setProperty('--hn-loading-spinner-size', `${this._size}px`);
  }
}

export default customElements.define('hn-loading-spinner', LoadingSpinner);
