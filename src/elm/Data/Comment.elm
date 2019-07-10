module Data.Comment exposing (Comment, author, commentDecoder, metadata, time, timeToString)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, optional, required)
import String.Extra as String
import Time


type Comment
    = Comment Metadata


type alias Metadata =
    { id : Int
    , by : String
    , time : Int
    , kids : List Comment
    , parent : Maybe Int
    , text : String
    }



-- INFO


author : Comment -> String
author (Comment details) =
    details.by


metadata : Comment -> Metadata
metadata (Comment details) =
    details


time : Comment -> Int
time (Comment details) =
    Time.toHour Time.utc <| Time.millisToPosix details.time


timeToString : Comment -> String
timeToString (Comment details) =
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


commentDecoder : Decoder Comment
commentDecoder =
    Decode.succeed Comment
        |> custom metadataDecoder


metadataDecoder : Decoder Metadata
metadataDecoder =
    Decode.succeed Metadata
        |> required "id" Decode.int
        |> optional "by" Decode.string "Anonymous"
        |> optional "time" Decode.int 0
        |> optional "kids" (Decode.list (Decode.lazy (\_ -> commentDecoder))) []
        |> optional "parent" (Decode.nullable Decode.int) Nothing
        |> optional "text" Decode.string ""
