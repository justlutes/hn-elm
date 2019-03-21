// WARNING: Do not manually modify this file. It was generated using:
// https://github.com/dillonkearns/elm-typescript-interop
// Type definitions for Elm ports

export namespace Elm {
  namespace Main {
    export interface App {
      ports: {
        initialize: {
          subscribe(callback: (data: string) => void): void
        }
        requestPosts: {
          subscribe(callback: (data: { category: string }) => void): void
        }
        requestedPosts: {
          send(data: any): void
        }
        testing: {
          subscribe(callback: (data: any) => void): void
        }
      };
    }
    export function init(options: {
      node?: HTMLElement | null;
      flags: number;
    }): Elm.Main.App;
  }
}