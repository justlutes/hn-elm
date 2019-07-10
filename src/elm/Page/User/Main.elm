module Page.User.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Firebase as Firebase
import Html exposing (Html)
import Page.User.Types exposing (Model, Msg(..), Status(..))
import Page.User.View as View
import Process
import Session exposing (Session)
import Task


type alias Model =
    Page.User.Types.Model


init : Session -> String -> ( Model, Cmd Msg )
init session userID =
    ( { session = session
      , user = Loading
      , userID = userID
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
    Page.User.Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Page.User.Types.update msg model


toSession : Model -> Session
toSession =
    Page.User.Types.toSession


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundUser
            { onUser = CompletedUserLoad
            , onFailure = PortFailure
            }
        ]
