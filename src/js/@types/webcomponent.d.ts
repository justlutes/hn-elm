export interface IConnectedComponent {
  connectedCallback: () => void;
  disconnectedCallback?: () => void;
}
