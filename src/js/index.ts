import { IApp } from "./@types";
import { Elm } from "../elm/Main.elm";
import { getTopStories, getNewStories, getBestStories } from "./api";

const app: IApp = Elm.Main.init();

app.ports.requestTopStories.subscribe(async (value: any) => {
  const topStories = await getTopStories();

  app.ports.requestedTopStories.send(topStories);
});
