module Data.Feed exposing (Feed(..), FeedContent, cursor, getPosts)

import Data.Post exposing (Post)


type Feed
    = Loading
    | LoadingSlowly
    | Loaded FeedContent
    | Failed


type alias FeedContent =
    { cursor : Maybe Int
    , posts : List Post
    }


cursor : Feed -> Maybe Int
cursor feed =
    case feed of
        Loaded content ->
            content.cursor

        _ ->
            Nothing


getPosts : Feed -> List Post
getPosts feed =
    case feed of
        Loaded content ->
            content.posts

        _ ->
            []
