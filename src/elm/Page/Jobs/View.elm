module Page.Jobs.View exposing (view)

import Html exposing (Html)
import Html.Attributes as Attributes
import Page.Jobs.Types exposing (..)
import Ui.Feed as Feed


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "News"
    , content = Html.div [ Attributes.class "content-wrapper" ] [ Feed.view LoadMore model.feed ]
    }
