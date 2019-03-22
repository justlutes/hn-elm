port module Data.Firebase exposing (Category(..), inBoundPosts, requestPosts, requestedPosts)

import Data.Post as Post exposing (Post)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode


type Category
    = Best
    | New
    | Top


port firebaseOutbound : Decode.Value -> Cmd msg


requestPosts : Category -> Maybe Int -> Cmd msg
requestPosts category maybeCursor =
    firebaseOutbound <|
        Encode.object
            [ ( "category", Encode.string <| categoryToString category )
            , ( "cursor"
              , case maybeCursor of
                    Just c ->
                        Encode.int c

                    Nothing ->
                        Encode.null
              )
            ]


{-| Receive all fetched news posts
-}
port requestedPosts : (Decode.Value -> msg) -> Sub msg


inBoundPosts : (List Post -> msg) -> (String -> msg) -> Sub msg
inBoundPosts onPosts onFailure =
    let
        postDecoder =
            Decode.succeed onPosts
                -- |> Decode.required "cursor" Decode.int
                |> Decode.required "posts" (Decode.list Post.postDecoder)
    in
    requestedPosts <|
        \value ->
            case Decode.decodeValue postDecoder value of
                Ok msg ->
                    msg

                Err e ->
                    onFailure <| Decode.errorToString e



-- HELPERS


categoryToString : Category -> String
categoryToString category =
    case category of
        Best ->
            "best"

        New ->
            "new"

        Top ->
            "top"
