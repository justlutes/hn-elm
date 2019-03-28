import { CustomElement } from '../../js/components/custom_element';
import './style.scss';

class CommentText extends CustomElement {
  private _content: string;

  constructor() {
    super();

    this._content = this.content;
    delete this.content;
  }

  connectedCallback() {
    this.buildTextNode();
  }

  set content(content: string) {
    if (this._content === content) return;
    this._content = content;
    this.buildTextNode();
  }

  private buildTextNode() {
    this.innerHTML = this._content;
  }
}

export default customElements.define('hn-parsed-text', CommentText);
