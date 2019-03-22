module Page.Home.View exposing (view)

import Data.Post as Post exposing (Post)
import Html exposing (Html)
import Page.Home.Types exposing (..)
import Ui.Loading.Main as UiLoading


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "News"
    , content = viewContent model
    }


viewContent : Model -> Html Msg
viewContent model =
    case model.posts of
        Loaded posts ->
            Html.div [] [ Html.text "posts" ]

        Loading ->
            UiLoading.view { color = "blue", size = 30 }

        LoadingSlowly ->
            UiLoading.view { color = "yellow", size = 25 }

        Failed ->
            Html.div [] [ Html.text "Error loading posts" ]
