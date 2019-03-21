"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const firebase = require("firebase/app");
require("firebase/database");
firebase.initializeApp({
    databaseURL: 'https://hacker-news.firebaseio.com',
});
const databaseRef = firebase.database().ref('/v0');
function itemWithInfo(items) {
    const promises = items.map((item) => __awaiter(this, void 0, void 0, function* () {
        const itemRef = databaseRef.child(`/item/${item}`);
        const itemSnapshot = yield itemRef.once('value');
        const itemValue = itemSnapshot.val();
        return itemValue;
    }));
    return Promise.all(promises);
}
function getTopStories() {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child('/topstories');
        const snapshot = yield ref.once('value');
        const storiesRef = snapshot.val();
        const storiesWithInfo = yield itemWithInfo(storiesRef);
        return storiesWithInfo;
    });
}
exports.getTopStories = getTopStories;
function getNewStories() {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child('/newstories');
        const snapshot = yield ref.once('value');
        const storiesRef = snapshot.val();
        const storiesWithInfo = yield itemWithInfo(storiesRef);
        return storiesWithInfo;
    });
}
exports.getNewStories = getNewStories;
function getBestStories() {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child('/beststories');
        const snapshot = yield ref.once('value');
        const storiesRef = snapshot.val();
        const storiesWithInfo = yield itemWithInfo(storiesRef);
        return storiesWithInfo;
    });
}
exports.getBestStories = getBestStories;
