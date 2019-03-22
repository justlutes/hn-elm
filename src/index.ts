import { Elm } from './Main';
import './css/styles.css';
import { getTopStories } from './js/api';
import initializeComponents from './js/components';

document.addEventListener('DOMContentLoaded', function() {
  const app: Elm.Main.App = Elm.Main.init({
    flags: 1,
  });

  initializeComponents(app);

  app.ports.initialize.subscribe(async (value: string) => {
    const posts = await getTopStories();

    app.ports.requestedPosts.send({ posts });
  });
});
