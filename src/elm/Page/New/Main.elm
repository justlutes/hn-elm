module Page.New.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Feed exposing (Feed(..))
import Data.Firebase as Firebase
import Html exposing (Html)
import Page.New.Types exposing (..)
import Page.New.View as View
import Process
import Session exposing (Session)
import Task
import Time


type alias Model =
    Page.New.Types.Model


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
    Page.New.Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Page.New.Types.update msg model


toSession : Model -> Session
toSession =
    Page.New.Types.toSession


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundPosts { onPosts = CompletedPostsLoad, onFailure = PortFailure }
        ]
