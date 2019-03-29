module Data.Feed exposing (Feed, cursor, getPosts)

import Data.Post exposing (Post)


type alias Feed =
    { cursor : Maybe Int
    , posts : List Post
    }


cursor : Feed -> Maybe Int
cursor feed =
    feed.cursor


getPosts : Feed -> List Post
getPosts feed =
    feed.posts
