import { Elm } from '../../Main';
import '../../UI/Loading';
import '../../UI/Comment/Text';
import '../../UI/ScrollToTop';
import iconDefinitions from './icon-definitions';
import FirebasePort from '../../Data/Firebase';

export default async (app: Elm.Main.App) => {
  // Embed global icon definitions
  iconDefinitions(app);

  // Port initializations
  FirebasePort(app);
};
