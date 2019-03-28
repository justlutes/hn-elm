export default (iconName: string, iconTitle: string): SVGSVGElement => {
  const SVG_NAMESPACE = 'http://www.w3.org/2000/svg';
  const XLINK_NAMESPACE = 'http://www.w3.org/1999/xlink';

  const svg = document.createElementNS(SVG_NAMESPACE, 'svg');
  svg.setAttributeNS(null, 'class', 'w-full h-full block fill-current');
  const use = document.createElementNS(SVG_NAMESPACE, 'use');
  use.setAttributeNS(XLINK_NAMESPACE, 'xlink:href', `#icon-${iconName}`);

  if (iconTitle) {
    const titleNode = document.createElementNS(SVG_NAMESPACE, 'title');
    const textNode = document.createTextNode(iconTitle);
    titleNode.appendChild(textNode);

    svg.setAttributeNS(null, 'role', 'img');
    svg.appendChild(titleNode);
  } else {
    svg.setAttributeNS(null, 'aria-hidden', 'true');
  }

  svg.appendChild(use);
  return svg;
};
