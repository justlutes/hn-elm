import { Elm } from '../Main';
import { getBestStories, getNewStories, getTopStories } from '../js/lib/api';
import { Item } from '../js/@types';

type Category = 'top' | 'new' | 'best';

export default function(app: Elm.Main.App) {
  app.ports.firebaseOutbound.subscribe(
    async ({ category, cursor }: { category: Category; cursor?: number }) => {
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

      if (cursor) {
        const lastIndex = posts.findIndex(post => post.id === cursor);
        posts = posts.slice(lastIndex + 1, lastIndex + 40);
      } else {
        posts = posts.slice(0, 40);
      }
      const newCursor = posts[posts.length - 1].id;

      app.ports.requestedPosts.send({ cursor: newCursor, posts });
    },
  );
}
