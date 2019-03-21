port module Firebase exposing (PortMsg, initialize, requestPosts, requestedPosts)

import Json.Decode exposing (Value)
import Post exposing (Post)


type alias PortMsg =
    { category : String
    }


port initialize : String -> Cmd msg


{-| Request all posts of type news
-}
port requestPosts : PortMsg -> Cmd msg


{-| Receive all fetched news posts
-}
port requestedPosts : (Json.Decode.Value -> msg) -> Sub msg


port testing : Json.Decode.Value -> Cmd msg
