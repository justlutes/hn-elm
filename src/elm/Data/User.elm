module Data.User exposing (User, timeToString, userDecoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import String.Extra as String
import Time


type alias User =
    { id : String
    , delay : Int
    , created : Int
    , karma : Int
    , about : String
    , submitted : List Int
    }


timeToString : User -> String
timeToString user =
    let
        posixTime =
            Time.millisToPosix (user.created * 1000)

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


userDecoder : Decoder User
userDecoder =
    Decode.succeed User
        |> required "id" Decode.string
        |> optional "delay" Decode.int 0
        |> optional "created" Decode.int 0
        |> optional "karma" Decode.int 0
        |> optional "about" Decode.string ""
        |> optional "submitted" (Decode.list Decode.int) []
