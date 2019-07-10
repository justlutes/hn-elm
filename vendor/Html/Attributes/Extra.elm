module Html.Attributes.Extra exposing (maybe)

import Html exposing (Attribute)
import Html.Attributes as Attributes
import Json.Encode as Encode


maybe : Maybe (Attribute msg) -> Attribute msg
maybe =
    Maybe.withDefault none


none : Attribute msg
none =
    Attributes.property "" Encode.null
