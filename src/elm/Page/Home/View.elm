module Page.Home.View exposing (view)

import Html exposing (Html)
import Page.Home.Types exposing (..)


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "hn-elm"
    , content =
        Html.div []
            [ Html.text "Home page" ]
    }
