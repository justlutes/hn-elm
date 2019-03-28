module Ui.Comment.Text exposing (view)

import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Json.Encode as Encode


content : String -> Attribute msg
content =
    Attributes.property "content" << Encode.string


view : String -> Html msg
view string =
    Html.node "hn-parsed-text" [ content string ] []
