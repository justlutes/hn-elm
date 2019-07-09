module Ui.Post exposing (buildLink, view, viewJobPost)

import Data.Post as Post exposing (Post)
import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Html.Attributes.Extra as Attributes
import Route exposing (Route)
import String.Extra as String
import Url


view : Post -> ( String, Html msg )
view post =
    let
        { descendants, id, title, score } =
            Post.metadata post
    in
    ( String.fromInt id
    , Html.li []
        [ Html.a
            ([]
                ++ buildLink post
            )
            [ Html.text title ]
        , Html.div [ Attributes.class "post-subcontent" ]
            [ subTitle post
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


viewJobPost : Post -> ( String, Html msg )
viewJobPost post =
    let
        { title, id, url } =
            Post.metadata post

        urlHost =
            Post.url post
                |> Maybe.map (\u -> u.host)
                |> Maybe.withDefault ""

        time =
            Post.time post
    in
    ( String.fromInt id
    , Html.li []
        [ Html.a (buildLink post)
            [ Html.span [] [ Html.text title ]
            , if String.isEmpty urlHost then
                Html.text ""

              else
                Html.span [ Attributes.class "post-host" ] [ Html.text ("(" ++ urlHost ++ ")") ]
            ]
        , Html.div [ Attributes.class "post-subcontent" ]
            [ Html.span []
                [ Html.text <|
                    String.concat
                        [ String.fromInt time
                        , String.pluralize " hour ago" " hours ago" time
                        ]
                ]
            ]
        ]
    )



-- HELPERS


subTitle : Post -> Html msg
subTitle post =
    let
        { by, score } =
            Post.metadata post
    in
    Html.span []
        [ Html.span
            []
            [ Html.text
                (String.fromInt score ++ " points by ")
            ]
        , Html.a
            [ Route.href (Route.User by) ]
            [ Html.text by ]
        , Html.span
            []
            [ Html.text (Post.timeToString post ++ " |") ]
        ]


buildLink : Post -> List (Attribute msg)
buildLink post =
    case Post.url post of
        Just url ->
            [ Attributes.href <| Url.toString url
            , Attributes.target "_blank"
            , Attributes.rel "noopener"
            ]

        Nothing ->
            [ Route.href (Route.Item <| Post.id post) ]
