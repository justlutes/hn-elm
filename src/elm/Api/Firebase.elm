port module Api.Firebase exposing (requestNews, requestedNews)

import Json.Decode exposing (Value)


type alias PortMsg =
    { message : String
    , payload : Value
    }


{-| Request all posts of type news
-}
port requestNews : PortMsg -> Cmd msg


{-| Receive all fetched news posts
-}
port requestedNews : (PortMsg -> msg) -> Sub msg
