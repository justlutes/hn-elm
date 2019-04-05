module Page.Jobs.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Feed exposing (Feed(..))
import Data.Firebase as Firebase
import Html exposing (Html)
import Page.Jobs.Types exposing (..)
import Page.Jobs.View as View
import Process
import Session exposing (Session)
import Task
import Time


type alias Model =
    Page.Jobs.Types.Model


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
    Page.Jobs.Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Page.Jobs.Types.update msg model


toSession : Model -> Session
toSession =
    Page.Jobs.Types.toSession


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundPosts { onPosts = CompletedPostsLoad, onFailure = PortFailure }
        ]
