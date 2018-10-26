module Page exposing (Page(..), PageLayout, view, viewErrors)

import Api exposing (Cred)
import Browser exposing (Document)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Route exposing (Route)
import Session exposing (Session)
import Username exposing (Username)
import Viewer exposing (Viewer)


type Page
    = Other
    | Home


type alias PageLayout =
    { title : String, content : Html msg }


view : Maybe Viewer -> Page -> PageLayout -> Document msg
view maybeViewer page { title, content } =
    { title = title
    , body = viewHeader page maybeViewer :: content :: [ viewFooter ]
    }


viewHeader : Page -> Maybe Viewer -> Html msg
viewHeader page maybeViewer =
    Html.nav []
        [ Html.div []
            [ Html.a [ Route.href Route.Home ]
                [ Html.text "hackernews" ]
            , Html.ul [] <|
                navbarLink page Route.Home [ Html.text "home" ]
                    :: viewMenu page maybeViewer
            ]
        ]


viewMenu : Page -> Maybe Viewer -> List (Html msg)
viewMenu page maybeViewer =
    let
        linkTo =
            navbarLink page
    in
    case maybeViewer of
        Just viewer ->
            let
                username =
                    Viewer.username viewer
            in
            [ Html.span [] [ Html.text "\u{00A0}Test" ] ]

        Nothing ->
            [ Html.span [] [ Html.text "\u{00A0}Test" ] ]


viewFooter : Html msg
viewFooter =
    Html.footer []
        [ Html.div [] [ Html.text "footer here " ] ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink page route content =
    Html.li
        [ Attributes.classList
            [ ( "active", isActive page route ) ]
        ]
        [ Html.a [ Route.href route ] content ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
            True

        _ ->
            False


viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""

    else
        Html.div
            [ Attributes.class "error-container" ]
        <|
            List.map (\error -> Html.p [] [ Html.text error ]) errors
                ++ [ Html.button
                        [ Events.onClick dismissErrors ]
                        [ Html.text "Ok" ]
                   ]
