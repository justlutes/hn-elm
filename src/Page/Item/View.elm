module Page.Item.View exposing (view)

import Data.Comment as Comment exposing (Comment)
import Data.Feed exposing (Feed)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Html.Keyed as Keyed
import Page.Item.Types exposing (..)
import Ui.Comment as Comment
import Ui.Loading.Main as UiLoading


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "News"
    , content = Html.div [ Attributes.class "content-wrapper" ] [ viewContent model ]
    }


viewContent : Model -> Html Msg
viewContent model =
    case model.comments of
        Loaded comments ->
            Html.div []
                [ Keyed.node "ul" [ Attributes.class "comment-list" ] <| List.map Comment.view comments
                ]

        Loading ->
            UiLoading.view { color = "#60b5cc", size = 30 }

        LoadingSlowly ->
            UiLoading.view { color = "yellow", size = 30 }

        Failed ->
            Html.div [] [ Html.text "Error loading comments" ]
