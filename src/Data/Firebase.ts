import { Elm } from '../Main';
import { getBestStories, getNewStories, getTopStories } from '../js/lib/api';
import { Item } from '../js/@types';

type Category = 'top' | 'new' | 'best';

export default function(app: Elm.Main.App) {
  app.ports.firebaseOutbound.subscribe(
    async ({ category, cursor }: { category: Category; cursor?: number }) => {
      console.log(category, cursor);
      let posts: Item[];
      switch (category) {
        case 'best':
          posts = await getBestStories();
          break;
        case 'new':
          posts = await getNewStories();
          break;
        case 'top':
          posts = await getTopStories();
          break;
        default:
          posts = await getTopStories();
          break;
      }

      app.ports.requestedPosts.send({ posts });
    },
  );
}
