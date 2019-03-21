module Page exposing (Page(..), view, viewErrors)

import Browser exposing (Document)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Route as Route
import Session exposing (Session)


type Page
    = Other
    | Home


view : Page -> { title : String, content : Html msg } -> Document msg
view page { title, content } =
    { title = title ++ " - HN"
    , body = viewHeader page :: content :: [ viewFooter ]
    }


viewHeader : Page -> Html msg
viewHeader page =
    Html.nav []
        [ Html.div []
            [ Html.a [ Route.href Route.Home ]
                [ Html.text "hn-elm" ]
            , Html.ul []
                [ Html.a [ Route.href Route.Home ]
                    [ Html.text "News" ]
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    Html.footer []
        [ Html.text "Footer here" ]


viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""

    else
        Html.div
            [ Html.Attributes.class "error-messages"
            , Html.Attributes.style "position" "fixed"
            , Html.Attributes.style "top" "0"
            , Html.Attributes.style "background" "rgb(250, 250, 250)"
            , Html.Attributes.style "padding" "20px"
            , Html.Attributes.style "border" "1px solid"
            ]
        <|
            List.map (\error -> Html.p [] [ Html.text error ]) errors
                ++ [ Html.button [ Html.Events.onClick dismissErrors ] [ Html.text "Ok" ] ]
