import { Elm } from '../elm/Main';
// import { getTopStories } from './api';
// import initializeComponents from './components';

document.addEventListener('DOMContentLoaded', function() {
  const app: Elm.Main.App = Elm.Main.init({
    flags: 1,
  });

  // initializeComponents(app);
  // app.ports.initialize.subscribe(() => console.log('initialized'));
});
// const app: IApp = Elm.Main.init();
// initializeComponents(app);

// app.ports.requestTopStories.subscribe(async (value: any) => {
//   const topStories = await getTopStories();

//   app.ports.requestedTopStories.send(topStories);
// });
