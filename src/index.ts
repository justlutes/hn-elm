import { Elm } from './Main';
import './css/styles.scss';
import initializeComponents from './js/components';

document.addEventListener('DOMContentLoaded', function() {
  const app: Elm.Main.App = Elm.Main.init({
    flags: 1,
  });

  initializeComponents(app);
});
