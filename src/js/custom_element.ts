import { IConnectedComponent } from './@types';

export abstract class CustomElement extends HTMLElement implements IConnectedComponent {
  abstract connectedCallback(): void;

  disconnectedCallback(): void {}
}
