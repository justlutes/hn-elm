module Data.Feed exposing (Feed, cursor)

import Data.Post exposing (Post)


type alias Feed =
    { cursor : Maybe Int
    , posts : List Post
    }


cursor : Feed -> Maybe Int
cursor feed =
    feed.cursor
