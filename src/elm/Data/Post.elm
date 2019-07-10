module Data.Post exposing (Post, author, id, metadata, postDecoder, time, timeToString, url)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, optional, required)
import String.Extra as String
import Time
import Url exposing (Url)


type Post
    = Post Metadata


type Type
    = Job
    | Story
    | Comment
    | Poll
    | PollOpt


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
    details.by


metadata : Post -> Metadata
metadata (Post details) =
    details


id : Post -> Int
id (Post details) =
    details.id


url : Post -> Maybe Url
url (Post details) =
    details.url
        |> Maybe.map Url.fromString
        |> Maybe.withDefault Nothing


time : Post -> Int
time (Post details) =
    Time.toHour Time.utc <| Time.millisToPosix details.time


timeToString : Post -> String
timeToString (Post details) =
    let
        posixTime =
            Time.millisToPosix (details.time * 1000)

        timeByHour =
            Time.toHour Time.utc posixTime
    in
    if timeByHour == 0 then
        let
            newTime =
                Time.toMinute Time.utc posixTime
        in
        String.concat
            [ " "
            , String.fromInt newTime
            , String.pluralize " minute ago" " minutes ago" newTime
            ]

    else
        String.concat
            [ " "
            , String.fromInt timeByHour
            , String.pluralize " hour ago" " hours ago" timeByHour
            ]



-- SERIALIZATION


postDecoder : Decoder Post
postDecoder =
    Decode.succeed Post
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
