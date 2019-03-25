module Page.Home.View exposing (view)

import Data.Feed exposing (Feed)
import Data.Post as Post exposing (Post)
import Html exposing (Html)
import Html.Events as Events
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
        Loaded { posts } ->
            Html.div []
                [ Html.div []
                    [ Html.button [ Events.onClick LoadMore ] [ Html.text "Load" ] ]
                , Html.div [] <| List.map viewPosts posts
                ]

        Loading ->
            UiLoading.view { color = "blue", size = 30 }

        LoadingSlowly ->
            UiLoading.view { color = "yellow", size = 30 }

        Failed ->
            Html.div [] [ Html.text "Error loading posts" ]


viewPosts : Post -> Html Msg
viewPosts post =
    let
        metadata =
            Post.metadata post
    in
    Html.div []
        [ Html.text <| String.fromInt metadata.id ]
