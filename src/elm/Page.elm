module Page exposing (Page(..), view, viewErrors)

import Browser exposing (Document)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events
import Route as Route exposing (Route)


type Page
    = Other
    | Home
    | New
    | Show
    | Ask
    | Jobs
    | Item
    | User


view : Page -> { title : String, content : Html msg } -> Document msg
view page { title, content } =
    { title = title ++ " - HN"
    , body =
        [ viewHeader page
        , Html.node "hn-icon-sprites" [] []
        , content
        , viewFooter page
        ]
    }


viewHeader : Page -> Html msg
viewHeader page =
    Html.nav []
        [ Html.a
            [ Route.href Route.Home
            , Attributes.attribute "aria-label" "View Home Page"
            ]
            [ Html.img
                [ Attributes.src "images/elm.png"
                , Attributes.class "nav-logo"
                , Attributes.alt "elm logo"
                ]
                []
            ]
        , viewMenu page
        ]


viewMenu : Page -> Html msg
viewMenu page =
    Html.ul [ Attributes.class "nav-menu" ]
        [ navLink page Route.Home [ Html.text "top" ]
        , navLink page Route.New [ Html.text "new" ]
        , navLink page Route.Show [ Html.text "show" ]
        , navLink page Route.Ask [ Html.text "ask" ]
        , navLink page Route.Jobs [ Html.text "jobs" ]
        ]


navLink : Page -> Route -> List (Html msg) -> Html msg
navLink page route innerContent =
    Html.li []
        [ Html.a
            [ Route.href route
            , Attributes.classList [ ( "active", isActive page route ) ]
            ]
            innerContent
        ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
            True

        ( New, Route.New ) ->
            True

        ( Show, Route.Show ) ->
            True

        ( Ask, Route.Ask ) ->
            True

        ( Jobs, Route.Jobs ) ->
            True

        _ ->
            False


viewFooter : Page -> Html msg
viewFooter page =
    Html.footer []
        [ Html.span [] [ Html.text "Hackernews - in Elm" ]
        , Html.ul []
            [ navLink page Route.Home [ Html.text "top" ]
            , navLink page Route.New [ Html.text "new" ]
            , navLink page Route.Show [ Html.text "show" ]
            , navLink page Route.Ask [ Html.text "ask" ]
            , navLink page Route.Jobs [ Html.text "jobs" ]
            ]
        ]


viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""

    else
        Html.div
            [ Attributes.class "error-messages"
            , Attributes.style "position" "fixed"
            , Attributes.style "top" "0"
            , Attributes.style "background" "rgb(250, 250, 250)"
            , Attributes.style "padding" "20px"
            , Attributes.style "border" "1px solid"
            ]
        <|
            List.map (\error -> Html.p [] [ Html.text error ]) errors
                ++ [ Html.button [ Html.Events.onClick dismissErrors ] [ Html.text "Ok" ] ]
