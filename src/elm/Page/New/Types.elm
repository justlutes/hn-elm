module Page.New.Types exposing (Model, Msg(..), toSession, update)

import Data.Feed as Feed exposing (Feed(..), FeedContent)
import Data.Firebase as Firebase
import Session exposing (Session)


type alias Model =
    { session : Session
    , feed : Feed
    }


type Msg
    = NoOp
    | GotSession Session
    | Initialize
    | CompletedPostsLoad FeedContent
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
        Feed.Loaded _ ->
            Just model.feed

        _ ->
            Nothing
