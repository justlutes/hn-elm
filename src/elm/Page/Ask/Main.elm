module Page.Ask.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Feed exposing (Feed(..))
import Data.Firebase as Firebase
import Html exposing (Html)
import Page.Ask.Types exposing (Model, Msg(..))
import Page.Ask.View as View
import Process
import Session exposing (Session)
import Task


type alias Model =
    Page.Ask.Types.Model


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , feed = Loading
      }
    , Task.perform (\_ -> Initialize) (Process.sleep 100)
    )


view : Model -> { title : String, content : Html Msg }
view model =
    let
        { title, content } =
            View.view model
    in
    { title = title, content = content }


type alias Msg =
    Page.Ask.Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Page.Ask.Types.update msg model


toSession : Model -> Session
toSession =
    Page.Ask.Types.toSession


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundPosts { onPosts = CompletedPostsLoad, onFailure = PortFailure }
        ]
