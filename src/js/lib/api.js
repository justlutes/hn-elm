"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __rest = (this && this.__rest) || function (s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
        t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
        for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) if (e.indexOf(p[i]) < 0)
            t[p[i]] = s[p[i]];
    return t;
};
Object.defineProperty(exports, "__esModule", { value: true });
const firebase = require("firebase/app");
require("firebase/database");
firebase.initializeApp({
    databaseURL: 'https://hacker-news.firebaseio.com',
});
const databaseRef = firebase.database().ref('/v0');
function itemsWithInfo(items) {
    const promises = items.map((item) => __awaiter(this, void 0, void 0, function* () {
        const itemRef = databaseRef.child(`/item/${item}`);
        const itemSnapshot = yield itemRef.once('value');
        const itemValue = itemSnapshot.val();
        return itemValue;
    }));
    return Promise.all(promises);
}
function getPost(id) {
    return __awaiter(this, void 0, void 0, function* () {
        const itemRef = databaseRef.child(`/item/${id}`);
        const itemSnapshot = yield itemRef.once('value');
        const itemValue = itemSnapshot.val();
        return itemValue;
    });
}
exports.getPost = getPost;
function getTopStories() {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child('/topstories');
        const snapshot = yield ref.once('value');
        const storiesRef = snapshot.val();
        const storiesWithInfo = yield itemsWithInfo(storiesRef);
        return storiesWithInfo;
    });
}
exports.getTopStories = getTopStories;
function getShowStories() {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child('/showstories');
        const snapshot = yield ref.once('value');
        const storiesRef = snapshot.val();
        const storiesWithInfo = yield itemsWithInfo(storiesRef);
        return storiesWithInfo;
    });
}
exports.getShowStories = getShowStories;
function getAskStories() {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child('/askstories');
        const snapshot = yield ref.once('value');
        const storiesRef = snapshot.val();
        const storiesWithInfo = yield itemsWithInfo(storiesRef);
        return storiesWithInfo;
    });
}
exports.getAskStories = getAskStories;
function getNewStories() {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child('/newstories');
        const snapshot = yield ref.once('value');
        const storiesRef = snapshot.val();
        const storiesWithInfo = yield itemsWithInfo(storiesRef);
        return storiesWithInfo;
    });
}
exports.getNewStories = getNewStories;
function getJobStories() {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child('/jobstories');
        const snapshot = yield ref.once('value');
        const storiesRef = snapshot.val();
        const storiesWithInfo = yield itemsWithInfo(storiesRef);
        return storiesWithInfo;
    });
}
exports.getJobStories = getJobStories;
function getBestStories() {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child('/beststories');
        const snapshot = yield ref.once('value');
        const storiesRef = snapshot.val();
        const storiesWithInfo = yield itemsWithInfo(storiesRef);
        return storiesWithInfo;
    });
}
exports.getBestStories = getBestStories;
function getComments(id) {
    return __awaiter(this, void 0, void 0, function* () {
        const ref = databaseRef.child(`/item/${id}`);
        const snapshot = yield ref.once('value');
        const { kids = [] } = snapshot.val();
        const comments = yield travelKids(kids);
        return comments;
    });
}
exports.getComments = getComments;
function travelKids(ids) {
    return __awaiter(this, void 0, void 0, function* () {
        if (ids && ids.length) {
            const items = yield itemsWithInfo(ids);
            return Promise.all(items.map((_a) => __awaiter(this, void 0, void 0, function* () {
                var { kids } = _a, rest = __rest(_a, ["kids"]);
                return Object.assign({}, rest, { kids: yield travelKids(kids) });
            })));
        }
        return Promise.resolve([]);
    });
}
