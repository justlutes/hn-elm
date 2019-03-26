module Data.Post exposing (Post, author, detailsDecoder, metadata, postDecoder, time, url)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, optional, required)
import Time exposing (Posix)


type Post
    = Post Details


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
    , deleted : Bool
    , type_ : Maybe Type
    , by : String
    , time : Int
    , text : String
    , parent : Maybe Int
    , poll : Maybe Int
    , kids : List Int
    , url : Maybe String
    , score : Int
    , title : String
    , parts : List Int
    , descendants : Int
    }



-- INFO


author : Post -> String
author (Post details) =
    details.metadata.by


metadata : Post -> Metadata
metadata (Post details) =
    details.metadata


url : Post -> Maybe String
url (Post details) =
    details.metadata.url


time : Post -> Int
time (Post details) =
    Time.toHour Time.utc <| Time.millisToPosix details.metadata.time



-- SERIALIZATION


postDecoder : Decoder Post
postDecoder =
    Decode.succeed Post
        |> custom detailsDecoder


detailsDecoder : Decoder Details
detailsDecoder =
    Decode.succeed Details
        |> custom metadataDecoder


metadataDecoder : Decoder Metadata
metadataDecoder =
    Decode.succeed Metadata
        |> required "id" Decode.int
        |> optional "deleted" Decode.bool False
        |> optional "type" (Decode.nullable decodeType) Nothing
        |> optional "by" Decode.string "Anonymous"
        |> optional "time" Decode.int 0
        |> optional "text" Decode.string ""
        |> optional "parent" (Decode.nullable Decode.int) Nothing
        |> optional "poll" (Decode.nullable Decode.int) Nothing
        |> optional "kids" (Decode.list Decode.int) []
        |> optional "url" (Decode.nullable Decode.string) Nothing
        |> optional "score" Decode.int 0
        |> optional "title" Decode.string "No title"
        |> optional "parts" (Decode.list Decode.int) []
        |> optional "descendants" Decode.int 0


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
