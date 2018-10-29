port module Api.Firebase exposing (PortMsg, requestTopStories, requestedTopStories)

import Json.Decode exposing (Value)


type alias PortMsg =
    { message : String
    , payload : Value
    }


{-| Request all posts of type news
-}
port requestTopStories : PortMsg -> Cmd msg


{-| Receive all fetched news posts
-}
port requestedTopStories : (PortMsg -> msg) -> Sub msg
