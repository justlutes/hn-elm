module Page.Home.Types exposing (Model, Msg(..), Status(..), toSession, update)

import Browser.Dom as Dom
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Http
import Page
import Post as Post exposing (Post)
import Session exposing (Session)


type alias Model =
    { session : Session
    , posts : Status (List Post)
    }


type Status a
    = Loading
    | LoadingSlowly
    | Loaded a
    | Failed


type Msg
    = NoOp
    | GotSession Session
    | CompletedPostsLoad (List Post)
    | PortFailure String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        CompletedPostsLoad posts ->
            let
                test =
                    Debug.log "test" <| List.head posts
            in
            ( { model | posts = Loaded posts }
            , Cmd.none
            )

        PortFailure err ->
            ( model, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session
