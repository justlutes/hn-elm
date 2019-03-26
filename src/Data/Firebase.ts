import { Elm } from '../Main';
import { getBestStories, getNewStories, getTopStories, getComments } from '../js/lib/api';
import { Item } from '../js/@types';

type Category = 'top' | 'new' | 'best' | 'comment';

export default function(app: Elm.Main.App) {
  app.ports.firebaseOutbound.subscribe(
    async ({
      category,
      cursor,
      parentId,
    }: {
      category: Category;
      cursor?: number;
      parentId?: number;
    }) => {
      let posts: Item[] = [];

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
        case 'comment':
          const comments = await getComments(parentId);
          console.log(comments);
          break;
        default:
          posts = await getTopStories();
          break;
      }

      if (cursor) {
        const lastIndex = posts.findIndex(post => post.id === cursor);
        posts = posts.slice(lastIndex + 1, lastIndex + 41);
      } else {
        posts = posts.slice(0, 40);
      }
      const newCursor = posts.length ? posts[posts.length - 1].id : null;

      app.ports.requestedPosts.send({ cursor: newCursor, posts });
    },
  );
}
