module Page.Show.View exposing (view)

import Data.Feed exposing (Feed)
import Data.Post as Post exposing (Post)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Html.Keyed as Keyed
import Page.Show.Types exposing (..)
import Ui.Loading.Main as UiLoading
import Ui.Post as Post


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "News"
    , content = Html.div [ Attributes.class "content-wrapper" ] [ viewContent model ]
    }


viewContent : Model -> Html Msg
viewContent model =
    case model.feed of
        Loaded { posts } ->
            Html.div []
                [ Keyed.node "ol" [ Attributes.class "post-list" ] <| List.map Post.view posts
                , loadMoreButton
                ]

        Loading ->
            Html.div [ Attributes.class "loading-wrapper" ]
                [ UiLoading.view { color = "#60b5cc", size = 30 } ]

        LoadingSlowly ->
            UiLoading.view { color = "yellow", size = 30 }

        Failed ->
            Html.div [] [ Html.text "Error loading posts" ]


loadMoreButton : Html Msg
loadMoreButton =
    Html.button [ Events.onClick LoadMore ] [ Html.text "Load More" ]
