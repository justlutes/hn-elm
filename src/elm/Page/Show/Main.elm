module Page.Show.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Feed exposing (Feed(..))
import Data.Firebase as Firebase
import Html exposing (Html)
import Page.Show.Types exposing (Model, Msg(..))
import Page.Show.View as View
import Process
import Session exposing (Session)
import Task


type alias Model =
    Page.Show.Types.Model


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
    Page.Show.Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Page.Show.Types.update msg model


toSession : Model -> Session
toSession =
    Page.Show.Types.toSession


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundPosts { onPosts = CompletedPostsLoad, onFailure = PortFailure }
        ]
