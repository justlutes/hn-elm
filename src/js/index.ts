import { IApp } from './@types';
import { Elm } from '../elm/Main.elm';
import { getTopStories } from './api';
import initializeComponents from './components';

const app: IApp = Elm.Main.init();
initializeComponents(app);

app.ports.requestTopStories.subscribe(async (value: any) => {
  const topStories = await getTopStories();

  app.ports.requestedTopStories.send(topStories);
});
