module Ui.Loading.Main exposing (view)

import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Json.Encode as Encode


size : Int -> Attribute msg
size =
    Attributes.property "size" << Encode.string << String.fromInt


color : String -> Attribute msg
color =
    Attributes.property "color" << Encode.string


view : { size : Int, color : String } -> Html msg
view config =
    Html.node "hn-loading-spinner"
        [ size config.size
        , color config.color
        ]
        []
