export interface IApp {
  ports: {
    requestTopStories: {
      subscribe: (v: any) => void;
    };
    requestedTopStories: {
      send: (v: any) => void;
    };
  };
}
