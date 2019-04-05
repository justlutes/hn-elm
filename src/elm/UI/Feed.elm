module Ui.Feed exposing (view)

import Data.Feed exposing (Feed(..))
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Html.Keyed as Keyed
import Ui.Loading.Main as UiLoading
import Ui.Post as Post
import Ui.ScrollToTop.Main as ScrollToTop


view : msg -> Feed -> Html msg
view loadMore feed =
    case feed of
        Loaded { posts } ->
            Html.div []
                [ Keyed.node "ol" [ Attributes.class "post-list" ] <| List.map Post.view posts
                , ScrollToTop.view
                , Html.button
                    [ Attributes.class "load-more-button"
                    , Events.onClick loadMore
                    ]
                    [ Html.text "Load More" ]
                ]

        Loading ->
            Html.div [ Attributes.class "loading-wrapper" ]
                [ UiLoading.view { color = "#60b5cc", size = 30 } ]

        LoadingSlowly ->
            UiLoading.view { color = "yellow", size = 30 }

        Failed ->
            Html.div [] [ Html.text "Error loading posts" ]
