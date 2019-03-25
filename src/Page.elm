module Page exposing (Page(..), view, viewErrors)

import Browser exposing (Document)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events
import Route as Route
import Session exposing (Session)


type Page
    = Other
    | Home
    | New
    | Show
    | Ask
    | Jobs


view : Page -> { title : String, content : Html msg } -> Document msg
view page { title, content } =
    { title = title ++ " - HN"
    , body = viewHeader page :: Html.node "hn-icon-sprites" [] [] :: content :: [ viewFooter ]
    }


viewHeader : Page -> Html msg
viewHeader page =
    Html.nav []
        [ Html.a [ Route.href Route.Home ]
            [ Html.img [ Attributes.src "images/elm.png", Attributes.class "nav-logo" ] [] ]
        , viewMenu page
        ]


viewMenu : Page -> Html msg
viewMenu page =
    Html.ul [ Attributes.class "nav-menu" ]
        [ Html.a
            [ Route.href Route.Home
            , Attributes.classList [ ( "active", page == Home ) ]
            ]
            [ Html.text "top" ]
        , Html.a
            [ Route.href Route.New
            , Attributes.classList [ ( "active", page == New ) ]
            ]
            [ Html.text "new" ]
        , Html.a
            [ Route.href Route.Show
            , Attributes.classList [ ( "active", page == Other ) ]
            ]
            [ Html.text "show" ]
        , Html.a
            [ Route.href Route.Ask
            , Attributes.classList [ ( "active", page == Ask ) ]
            ]
            [ Html.text "ask" ]
        , Html.a
            [ Route.href Route.Jobs
            , Attributes.classList [ ( "active", page == Jobs ) ]
            ]
            [ Html.text "jobs" ]
        ]


viewFooter : Html msg
viewFooter =
    Html.footer []
        [ Html.text "Hackernews - in Elm" ]


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
