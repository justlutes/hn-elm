module Page.Ask.Types exposing (Model, Msg(..), Status(..), toSession, update)

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
    , feed : Status Feed
    }


type Status a
    = Loading
    | LoadingSlowly
    | Loaded a
    | Failed


type Msg
    = NoOp
    | GotSession Session
    | Initialize
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
            ( model, Firebase.requestPosts Firebase.Ask Nothing )

        LoadMore ->
            let
                maybeCursor =
                    model
                        |> getFeed
                        |> Maybe.map Feed.cursor
                        |> Maybe.withDefault Nothing
            in
            ( model
            , Firebase.requestPosts Firebase.Ask maybeCursor
            )

        PortFailure err ->
            ( { model | feed = Failed }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session


getFeed : Model -> Maybe Feed
getFeed model =
    case model.feed of
        Loaded feed ->
            Just feed

        _ ->
            Nothing
