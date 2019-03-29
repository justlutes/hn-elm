import { Elm } from '../../elm/Main';
import '../../elm/UI/Loading';
import '../../elm/UI/Comment/Text';
import '../../elm/UI/ScrollToTop';
import iconDefinitions from './icon-definitions';
import FirebasePort from '../../elm/Data/Firebase';

export default async (app: Elm.Main.App) => {
  // Embed global icon definitions
  iconDefinitions(app);

  // Port initializations
  FirebasePort(app);
};
