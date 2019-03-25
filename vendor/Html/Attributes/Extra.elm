module Html.Attributes.Extra exposing (maybe)

import Html exposing (Attribute)
import Html.Attributes exposing (..)
import Json.Encode as Encode


maybe : Maybe (Attribute msg) -> Attribute msg
maybe =
    Maybe.withDefault none


none : Attribute msg
none =
    property "" Encode.null
