port module Data.Firebase exposing (Category(..), Config, inBoundPosts, requestPosts, requestedPosts)

import Data.Feed exposing (Feed)
import Data.Post as Post exposing (Post)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode


type Category
    = Best
    | New
    | Top


type alias Config msg =
    { onPosts : Feed -> msg
    , onFailure : String -> msg
    }


port firebaseOutbound : Decode.Value -> Cmd msg


requestPosts : Category -> Maybe Int -> Cmd msg
requestPosts category maybeCursor =
    firebaseOutbound <|
        Encode.object
            [ ( "category", Encode.string <| categoryToString category )
            , ( "cursor"
              , case maybeCursor of
                    Just cursor ->
                        Encode.int cursor

                    Nothing ->
                        Encode.null
              )
            ]


{-| Receive all fetched news posts
-}
port requestedPosts : (Decode.Value -> msg) -> Sub msg


inBoundPosts : Config msg -> Sub msg
inBoundPosts config =
    let
        postDecoder =
            Decode.succeed Feed
                |> Decode.optional "cursor" (Decode.nullable Decode.int) Nothing
                |> Decode.required "posts" (Decode.list Post.postDecoder)
                |> Decode.map config.onPosts
    in
    requestedPosts <|
        \value ->
            case Decode.decodeValue postDecoder value of
                Ok msg ->
                    msg

                Err e ->
                    config.onFailure <| Decode.errorToString e



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
