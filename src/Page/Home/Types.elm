module Page.Home.Types exposing (Model, Msg(..), Status(..), toSession, update)

import Browser.Dom as Dom
import Data.Feed as Feed exposing (Feed)
import Data.Firebase as Firebase
import Data.Post as Post exposing (Post)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Http
import Page
import Session exposing (Session)


type alias Model =
    { session : Session
    , posts : Status Feed
    }


type Status a
    = Loading
    | LoadingSlowly
    | Loaded a
    | Failed


type Msg
    = NoOp
    | GotSession Session
    | CompletedPostsLoad Feed
    | PortFailure String
    | LoadMore


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        CompletedPostsLoad posts ->
            ( { model | posts = Loaded posts }
            , Cmd.none
            )

        LoadMore ->
            let
                maybeCursor =
                    case getFeed model of
                        Just feed ->
                            Feed.cursor feed

                        Nothing ->
                            Nothing
            in
            ( model
            , Firebase.requestPosts Firebase.Top maybeCursor
            )

        PortFailure err ->
            ( model, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session


getFeed : Model -> Maybe Feed
getFeed model =
    case model.posts of
        Loaded feed ->
            Just feed

        _ ->
            Nothing
