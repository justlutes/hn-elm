module Ui.Post exposing (view)

import Data.Post as Post exposing (Post)
import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Html.Attributes.Extra as Attributes
import Route exposing (Route)


view : Post -> ( String, Html msg )
view post =
    let
        { id, url, title } =
            Post.metadata post
    in
    ( String.fromInt id
    , Html.li []
        [ Html.a
            ([]
                ++ buildLink post
            )
            [ title
                |> Maybe.map Html.text
                |> Maybe.withDefault (Html.text "No title")
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
