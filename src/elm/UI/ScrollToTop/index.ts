import { CustomElement } from '../../../js/components/custom_element';
import './style.scss';

const OFFSET_THRESHOLD = 950;

class ScrollToTop extends CustomElement {
  constructor() {
    super();
  }

  connectedCallback() {
    this.scrollHandler = this.scrollHandler.bind(this);
    this.classList.add('hidden');

    this.addEventListener('click', _ => window.scroll({ top: 0, behavior: 'smooth' }));
    document.addEventListener('scroll', this.scrollHandler);
  }

  disconnectedCallback() {
    document.removeEventListener('scroll', this.scrollHandler);
  }

  private scrollHandler() {
    const isTop = window.pageYOffset === 0;
    const isPastOffset = window.pageYOffset > OFFSET_THRESHOLD;

    if (isPastOffset) {
      this.classList.remove('hidden');
    } else if (isTop) {
      this.classList.add('hidden');
    }
  }
}

export default customElements.define('hn-scroll-to-top', ScrollToTop);
