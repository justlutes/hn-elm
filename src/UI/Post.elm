module Ui.Post exposing (buildLink, view)

import Data.Post as Post exposing (Post)
import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Html.Attributes.Extra as Attributes
import Route exposing (Route)
import String.Extra as String


view : Post -> ( String, Html msg )
view post =
    let
        { descendants, id, url, title, score } =
            Post.metadata post

        time =
            Post.time post
    in
    ( String.fromInt id
    , Html.li []
        [ Html.a
            ([]
                ++ buildLink post
            )
            [ Html.text title ]
        , Html.div [ Attributes.class "post-subcontent" ]
            [ Html.span []
                [ Html.text <|
                    String.concat
                        [ String.fromInt score
                        , " points"
                        , " by "
                        , Post.author post
                        , " "
                        , String.fromInt time
                        , String.pluralize " hour ago" " hours ago" time
                        , " |"
                        ]
                ]
            , Html.a
                [ Attributes.class "commment-link"
                , Route.href (Route.Item id)
                ]
                [ Html.text <|
                    String.fromInt descendants
                        ++ String.pluralize " comment" " comments" descendants
                ]
            ]
        ]
    )



-- HELPERS


buildLink : Post -> List (Attribute msg)
buildLink post =
    case Post.url post of
        Just url ->
            [ Attributes.href url
            , Attributes.target "_blank"
            , Attributes.rel "noopener"
            ]

        Nothing ->
            [ Route.href Route.Ask ]
