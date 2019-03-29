module Ui.Comment exposing (view)

import Data.Comment as Comment exposing (Comment)
import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Html.Attributes.Extra as Attributes
import Route exposing (Route)
import String.Extra as String
import Ui.Comment.Text as CommentText


view : Comment -> ( String, Html msg )
view comment =
    let
        { id } =
            Comment.metadata comment
    in
    ( String.fromInt id
    , Html.li []
        [ viewComment comment ]
    )


viewComment : Comment -> Html msg
viewComment comment =
    let
        { text, kids } =
            Comment.metadata comment

        time =
            Comment.time comment
    in
    Html.div [ Attributes.class "comment-content" ]
        [ Html.div []
            [ Html.span [] [ Html.text <| Comment.author comment ]
            , Html.text " | "
            , Html.span []
                [ Html.text <|
                    String.concat
                        [ String.fromInt time
                        , String.pluralize " hour ago" " hours ago" time
                        ]
                ]
            ]
        , Html.div []
            [ CommentText.view text ]
        , if List.isEmpty kids then
            Html.div [] [ Html.text "" ]

          else
            Html.div [ Attributes.class "child-comment" ] (List.map viewComment kids)
        ]
