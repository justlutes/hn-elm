module Page.Item.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Firebase as Firebase
import Html exposing (Html)
import Page.Item.Types exposing (..)
import Page.Item.View as View
import Process
import Session exposing (Session)
import Task
import Time


type alias Model =
    Page.Item.Types.Model


init : Session -> Int -> ( Model, Cmd Msg )
init session id =
    ( { session = session
      , comments = Loading
      , postId = id
      , parent = Loading
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
    Page.Item.Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Page.Item.Types.update msg model


toSession : Model -> Session
toSession =
    Page.Item.Types.toSession


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundComments { onComments = CompletedCommentsLoad, onFailure = PortFailure }
        ]
