port module Firebase exposing (PortMsg, inBoundPosts, initialize, requestPosts, requestedPosts)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Decode
import Json.Encode
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
port requestedPosts : (Decode.Value -> msg) -> Sub msg


inBoundPosts : (List Post -> msg) -> (String -> msg) -> Sub msg
inBoundPosts onPosts onFailure =
    let
        postDecoder =
            Decode.succeed onPosts
                |> Decode.required "posts" (Decode.list Post.postDecoder)
    in
    requestedPosts <|
        \value ->
            case Decode.decodeValue postDecoder value of
                Ok msg ->
                    msg

                Err e ->
                    onFailure <| Decode.errorToString e
