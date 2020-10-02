module Page.User.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Firebase as Firebase
import Data.User as User exposing (User)
import Html exposing (Html)
import Html.Attributes as Attributes
import Process
import Session exposing (Session)
import Task
import Ui.Comment.Text as CommentText
import Ui.Loading.Main as UiLoading


type Status a
    = Loading
    | LoadingSlowly
    | Loaded a
    | Failed


type alias Model =
    { session : Session
    , user : Status User
    , userID : String
    }


init : Session -> String -> ( Model, Cmd Msg )
init session userID =
    ( { session = session
      , user = Loading
      , userID = userID
      }
    , Task.perform (\_ -> Initialize) (Process.sleep 100)
    )


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


type Msg
    = NoOp
    | Initialize
    | GotSession Session
    | CompletedUserLoad User
    | PortFailure String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Initialize ->
            ( model, Firebase.requestUser model.userID )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        CompletedUserLoad user ->
            ( { model
                | user = Loaded user
              }
            , Cmd.none
            )

        PortFailure _ ->
            ( { model | user = Failed }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundUser
            { onUser = CompletedUserLoad
            , onFailure = PortFailure
            }
        ]
