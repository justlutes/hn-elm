module Ui.Comment exposing (view)

import Data.Comment as Comment exposing (Comment)
import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Html.Attributes.Extra as Attributes
import Html.Events as Events
import Route exposing (Route)
import Set exposing (Set)
import String.Extra as String
import Ui.Comment.Text as CommentText


view : (Int -> msg) -> Set Int -> Comment -> ( String, Html msg )
view toggle toggledList comment =
    let
        { id } =
            Comment.metadata comment
    in
    ( String.fromInt id
    , Html.li []
        [ viewComment toggle toggledList comment ]
    )


viewComment : (Int -> msg) -> Set Int -> Comment -> Html msg
viewComment toggle toggledList comment =
    let
        { text, kids, id } =
            Comment.metadata comment

        closed =
            Set.member id toggledList

        time =
            Comment.time comment
    in
    if closed then
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
                , Html.button
                    [ Attributes.class "comment-counter"
                    , Events.onClick <| toggle id
                    ]
                    [ Html.text <|
                        String.concat
                            [ "[ +"
                            , (List.length kids + 1)
                                |> String.fromInt
                            , " ]"
                            ]
                    ]
                ]
            ]

    else
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
                , Html.button
                    [ Attributes.class "comment-counter"
                    , Events.onClick <| toggle id
                    ]
                    [ Html.text "[-]" ]
                ]
            , Html.div []
                [ CommentText.view text ]
            , if List.isEmpty kids then
                Html.div [] [ Html.text "" ]

              else
                Html.div [ Attributes.class "child-comment" ]
                    (List.map (viewComment toggle toggledList) kids)
            ]
