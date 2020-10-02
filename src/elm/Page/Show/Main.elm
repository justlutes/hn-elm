module Page.Show.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Feed as Feed exposing (Feed(..))
import Data.Firebase as Firebase
import Html exposing (Html)
import Html.Attributes as Attributes
import Process
import Session exposing (Session)
import Task
import Ui.Feed as Feed


type alias Model =
    { session : Session
    , feed : Feed
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , feed = Loading
      }
    , Task.perform (\_ -> Initialize) (Process.sleep 100)
    )


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "News"
    , content = Html.div [ Attributes.class "content-wrapper" ] [ Feed.view LoadMore model.feed ]
    }


type Msg
    = NoOp
    | GotSession Session
    | Initialize
    | CompletedPostsLoad Feed.FeedContent
    | PortFailure String
    | LoadMore


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        CompletedPostsLoad { cursor, posts } ->
            let
                modelPosts =
                    model
                        |> getFeed
                        |> Maybe.map Feed.getPosts
                        |> Maybe.withDefault []
            in
            ( { model
                | feed = Loaded { cursor = cursor, posts = modelPosts ++ posts }
              }
            , Cmd.none
            )

        Initialize ->
            ( model, Firebase.requestPosts Firebase.Show Nothing )

        LoadMore ->
            let
                maybeCursor =
                    model
                        |> getFeed
                        |> Maybe.map Feed.cursor
                        |> Maybe.withDefault Nothing
            in
            ( model
            , Firebase.requestPosts Firebase.Show maybeCursor
            )

        PortFailure _ ->
            ( { model | feed = Failed }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session


getFeed : Model -> Maybe Feed
getFeed model =
    case model.feed of
        Loaded _ ->
            Just model.feed

        _ ->
            Nothing


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundPosts { onPosts = CompletedPostsLoad, onFailure = PortFailure }
        ]
