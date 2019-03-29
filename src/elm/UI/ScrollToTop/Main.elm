module Ui.ScrollToTop.Main exposing (view)

import Html exposing (Html)
import Html.Attributes as Attributes


view : Html msg
view =
    Html.node "hn-scroll-to-top"
        []
        [ Html.button []
            [ Html.span [] [ Html.text "^" ]
            , Html.span [] [ Html.text "Back to Top" ]
            ]
        ]
