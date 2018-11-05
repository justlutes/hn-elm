module Post exposing (Post, author, detailsDecoder, metadata)

import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, optional, required)
import Time


type Post a
    = Post Details a


type Type
    = Job
    | Story
    | Comment
    | Poll
    | PollOpt


type alias Details =
    { metadata : Metadata
    }


type alias Metadata =
    { id : Int
    , deleted : Maybe Bool
    , type_ : Maybe Type
    , by : Maybe String
    , time : Maybe Time.Posix
    , text : Maybe String
    , parent : Maybe Int
    , poll : Maybe Int
    , kids : List Int
    , url : Maybe String
    , score : Maybe Int
    , title : Maybe String
    , parts : List Int
    , descendants : Maybe Int
    }



-- INFO


author : Post a -> String
author (Post details _) =
    case details.metadata.by of
        Nothing ->
            "Anonymous"

        Just by ->
            by


metadata : Post a -> Metadata
metadata (Post details _) =
    details.metadata



-- SERIALIZATION


detailsDecoder : Decoder Details
detailsDecoder =
    Decode.succeed Details
        |> custom metadataDecoder


metadataDecoder : Decoder Metadata
metadataDecoder =
    Decode.succeed Metadata
        |> required "id" Decode.int
        |> optional "deleted" (Decode.nullable Decode.bool) Nothing
        |> optional "type" (Decode.nullable decodeType) Nothing
        |> optional "by" (Decode.nullable Decode.string) Nothing
        |> optional "time" (Decode.nullable Iso8601.decoder) Nothing
        |> optional "text" (Decode.nullable Decode.string) Nothing
        |> optional "parent" (Decode.nullable Decode.int) Nothing
        |> optional "poll" (Decode.nullable Decode.int) Nothing
        |> optional "kids" (Decode.list Decode.int) []
        |> optional "url" (Decode.nullable Decode.string) Nothing
        |> optional "score" (Decode.nullable Decode.int) Nothing
        |> optional "title" (Decode.nullable Decode.string) Nothing
        |> optional "parts" (Decode.list Decode.int) []
        |> optional "descendants" (Decode.nullable Decode.int) Nothing


decodeType : Decoder Type
decodeType =
    Decode.string
        |> Decode.andThen
            (\s ->
                case s of
                    "job" ->
                        Decode.succeed Job

                    "story" ->
                        Decode.succeed Story

                    "comment" ->
                        Decode.succeed Comment

                    "poll" ->
                        Decode.succeed Poll

                    "pollopt" ->
                        Decode.succeed PollOpt

                    _ ->
                        Decode.fail "Unkown post type"
            )
