import {Item} from '../../js/@types';
import {getAskStories, getBestStories, getComments, getJobStories, getNewStories, getPost, getShowStories, getTopStories, getUser,} from '../../js/lib/api';
import {Elm} from '../Main';

interface FirebaseCmds {
  cmd: 'RequestPosts'|'RequestComment'|'RequestUser';
}

interface RequestPosts extends FirebaseCmds {
  category: Category;
  cursor?: number;
}

interface RequestComment extends FirebaseCmds {
  parentId: number;
}

interface RequestUser extends FirebaseCmds {
  id: string;
}

type Category = 'top'|'new'|'best'|'show'|'ask'|'job';

export default function(app: Elm.Main.App) {
  // Get Firebase posts based on category type and cursor
  async function requestPosts({cmd, category, cursor}: RequestPosts) {
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
      case 'show':
        posts = await getShowStories();
        break;
      case 'ask':
        posts = await getAskStories();
        break;
      case 'job':
        posts = await getJobStories();
        break;
    }

    if (cursor) {
      const lastIndex = posts.findIndex(post => post.id === cursor);
      posts = posts.slice(lastIndex + 1, lastIndex + 41);
    } else {
      posts = posts.slice(0, 40);
    }
    const newCursor = posts.length ? posts[posts.length - 1].id : null;

    app.ports.requestedContent.send({cmd, cursor: newCursor, posts});
  }

  // Get Firebase comments based on parent id
  async function requestComments({cmd, parentId}: RequestComment) {
    const comments = await getComments(parentId);
    const post = await getPost(parentId);
    app.ports.requestedContent.send({cmd, comments, post});
  }

  // Get Hackernews user based on id
  async function requestUser({cmd, id}: RequestUser) {
    const user = await getUser(id);
    app.ports.requestedContent.send({cmd, user});
  }

  app.ports.firebaseOutbound.subscribe(async (message: FirebaseCmds) => {
    switch (message.cmd) {
      case 'RequestPosts':
        return requestPosts(message as RequestPosts);

      case 'RequestComment':
        return requestComments(message as RequestComment);

      case 'RequestUser':
        return requestUser(message as RequestUser);
    }
  });
}
