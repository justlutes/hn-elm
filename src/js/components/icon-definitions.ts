import { Elm } from '../../Main';

export default async function(app: Elm.Main.App) {
  const icons = (await import(/* webpackChunkname: 'icons-svg' */ '../../assets/images/Icons.svg')) as unknown;
  customElements.define(
    'hn-icon-sprites',
    class extends HTMLElement {
      connectedCallback() {
        const div = document.createElement('div');
        div.style.display = 'none';
        const svgContent = icons as string;
        div.innerHTML = svgContent;
        this.appendChild(div);
      }
    },
  );
}
