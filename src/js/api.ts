import * as firebase from 'firebase/app';
import 'firebase/database';
import { Item } from './@types';

firebase.initializeApp({
  databaseURL: 'https://hacker-news.firebaseio.com',
});

const databaseRef = firebase.database().ref('/v0');

function itemWithInfo(items: number[]): Promise<Item[]> {
  const promises: Promise<Item>[] = items.map(async (item: number) => {
    const itemRef = databaseRef.child(`/item/${item}`);
    const itemSnapshot = await itemRef.once('value');
    const itemValue: Item = itemSnapshot.val();

    return itemValue;
  });

  return Promise.all(promises);
}

export async function getTopStories(): Promise<Item[]> {
  const ref = databaseRef.child('/topstories');
  const snapshot = await ref.once('value');
  const storiesRef = snapshot.val();
  const storiesWithInfo: Item[] = await itemWithInfo(storiesRef);

  return storiesWithInfo;
}

export async function getNewStories(): Promise<Item[]> {
  const ref = databaseRef.child('/newstories');
  const snapshot = await ref.once('value');
  const storiesRef = snapshot.val();
  const storiesWithInfo: Item[] = await itemWithInfo(storiesRef);

  return storiesWithInfo;
}

export async function getBestStories(): Promise<Item[]> {
  const ref = databaseRef.child('/beststories');
  const snapshot = await ref.once('value');
  const storiesRef = snapshot.val();
  const storiesWithInfo: Item[] = await itemWithInfo(storiesRef);

  return storiesWithInfo;
}
