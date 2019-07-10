module Page.User.View exposing (view)

import Data.User as User exposing (User)
import Html exposing (Html)
import Html.Attributes as Attributes
import Page.User.Types exposing (Model, Msg, Status(..))
import Ui.Comment.Text as CommentText
import Ui.Loading.Main as UiLoading


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Profile - " ++ model.userID
    , content =
        Html.div [ Attributes.class "content-wrapper" ]
            [ viewContent model ]
    }


viewContent : Model -> Html Msg
viewContent model =
    case model.user of
        Loaded user ->
            Html.div []
                [ viewUser user ]

        Loading ->
            Html.div
                [ Attributes.class "loading-wrapper" ]
                [ UiLoading.view { color = "#60b5cc", size = 30 } ]

        LoadingSlowly ->
            Html.div
                [ Attributes.class "loading-wrapper" ]
                [ UiLoading.view { color = "yellow", size = 30 } ]

        Failed ->
            Html.div [] [ Html.text "Error loading user" ]


viewUser : User -> Html Msg
viewUser user =
    Html.div
        [ Attributes.class "user-info" ]
        [ Html.h3 [] [ Html.text user.id ]
        , Html.div []
            [ Html.span [] [ Html.text "joined " ]
            , Html.strong [] [ Html.text <| User.timeToString user ]
            , Html.span [] [ Html.text " and has " ]
            , Html.strong [] [ Html.text <| String.fromInt user.karma ]
            , Html.span [] [ Html.text " karma" ]
            ]
        , Html.div
            [ Attributes.class "user-categories" ]
            [ Html.a
                [ Attributes.href ("https://news.ycombinator.com/submitted?id=" ++ user.id)
                , Attributes.target "_blank"
                ]
                [ Html.text "submissions" ]
            , Html.span [] [ Html.text " / " ]
            , Html.a
                [ Attributes.href ("https://news.ycombinator.com/threads?id=" ++ user.id)
                , Attributes.target "_blank"
                ]
                [ Html.text "comments" ]
            , Html.span [] [ Html.text " / " ]
            , Html.a
                [ Attributes.href ("https://news.ycombinator.com/favorites?id=" ++ user.id)
                , Attributes.target "_blank"
                ]
                [ Html.text "favorites" ]
            ]
        , Html.span
            [ Attributes.class "user-sub" ]
            [ CommentText.view user.about ]
        ]
