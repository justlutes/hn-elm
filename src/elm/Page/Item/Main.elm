module Page.Item.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Comment exposing (Comment)
import Data.Firebase as Firebase
import Data.Post as Post exposing (Post)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Keyed as Keyed
import Process
import Session exposing (Session)
import Set exposing (Set)
import String.Extra as String
import Task
import Ui.Comment as Comment
import Ui.Comment.Text as CommentText
import Ui.Loading.Main as UiLoading
import Ui.Post as Post


type Status a
    = Loading
    | LoadingSlowly
    | Loaded a
    | Failed


type alias Model =
    { session : Session
    , comments : Status (List Comment)
    , postId : Int
    , parent : Status Post
    , toggledComments : Set Int
    }


init : Session -> Int -> ( Model, Cmd Msg )
init session id =
    ( { session = session
      , comments = Loading
      , postId = id
      , parent = Loading
      , toggledComments = Set.empty
      }
    , Task.perform (\_ -> Initialize) (Process.sleep 100)
    )


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
                , Keyed.node "ul" [ Attributes.class "comment-list" ] <| List.map (Comment.view ToggleComment model.toggledComments) comments
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
        { title, score, text } =
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


type Msg
    = NoOp
    | Initialize
    | GotSession Session
    | CompletedCommentsLoad ( Post, List Comment )
    | PortFailure String
    | ToggleComment Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        CompletedCommentsLoad ( post, comments ) ->
            ( { model
                | comments = Loaded comments
                , parent = Loaded post
              }
            , Cmd.none
            )

        Initialize ->
            ( model
            , Firebase.requestComments model.postId
            )

        PortFailure _ ->
            ( { model | comments = Failed }
            , Cmd.none
            )

        ToggleComment id ->
            if Set.member id model.toggledComments then
                ( { model | toggledComments = Set.remove id model.toggledComments }
                , Cmd.none
                )

            else
                ( { model | toggledComments = Set.insert id model.toggledComments }
                , Cmd.none
                )


toSession : Model -> Session
toSession model =
    model.session


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundComments { onComments = CompletedCommentsLoad, onFailure = PortFailure }
        ]
