module Page.Item.View exposing (view)

import Data.Comment as Comment exposing (Comment)
import Data.Post as Post exposing (Post)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Keyed as Keyed
import Page.Item.Types exposing (..)
import Route exposing (Route)
import String.Extra as String
import Ui.Comment as Comment
import Ui.Comment.Text as CommentText
import Ui.Loading.Main as UiLoading
import Ui.Post as Post


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "News"
    , content = Html.div [ Attributes.class "content-wrapper" ] [ viewContent model ]
    }


viewContent : Model -> Html Msg
viewContent model =
    case ( model.comments, model.parent ) of
        ( Loaded comments, Loaded parent ) ->
            Html.div []
                [ viewParent parent
                , Keyed.node "ul" [ Attributes.class "comment-list" ] <| List.map Comment.view comments
                ]

        ( Loading, Loading ) ->
            Html.div [ Attributes.class "loading-wrapper" ]
                [ UiLoading.view { color = "#60b5cc", size = 30 } ]

        ( LoadingSlowly, LoadingSlowly ) ->
            UiLoading.view { color = "yellow", size = 30 }

        ( Failed, Failed ) ->
            Html.div [] [ Html.text "Error loading comments" ]

        ( _, _ ) ->
            Html.div [] [ Html.text "Error loading content" ]


viewParent : Post -> Html Msg
viewParent post =
    let
        { descendants, id, url, title, score, text } =
            Post.metadata post

        time =
            Post.time post
    in
    Html.div [ Attributes.class "comment-parent" ]
        [ Html.a
            (Post.buildLink post)
            [ Html.text title ]
        , Html.div [ Attributes.class "post-subcontent" ]
            [ Html.span []
                [ Html.text <|
                    String.concat
                        [ String.fromInt score
                        , " points"
                        , " by "
                        , Post.author post
                        , " "
                        , String.fromInt time
                        , String.pluralize " hour ago" " hours ago" time
                        ]
                ]
            , if String.isEmpty text then
                Html.text ""

              else
                Html.div [ Attributes.class "parent-text" ] [ CommentText.view text ]
            ]
        ]
