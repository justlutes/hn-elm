module Data.User exposing (User, userDecoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)


type alias User =
    { id : String
    , delay : Int
    , created : Int
    , karma : Int
    , about : String
    , submitted : List Int
    }


userDecoder : Decoder User
userDecoder =
    Decode.succeed User
        |> required "id" Decode.string
        |> optional "delay" Decode.int 0
        |> optional "created" Decode.int 0
        |> optional "karma" Decode.int 0
        |> optional "about" Decode.string ""
        |> optional "submitted" (Decode.list Decode.int) []
