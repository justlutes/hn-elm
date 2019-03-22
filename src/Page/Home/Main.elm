module Page.Home.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Firebase as Firebase
import Html exposing (Html)
import Page.Home.Types exposing (..)
import Page.Home.View as View
import Session exposing (Session)


type alias Model =
    Page.Home.Types.Model


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , posts = Loading
      }
    , Firebase.requestPosts Firebase.Top Nothing
    )


view : Model -> { title : String, content : Html Msg }
view model =
    let
        { title, content } =
            View.view model
    in
    { title = title, content = content }


type alias Msg =
    Page.Home.Types.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Page.Home.Types.update msg model


toSession : Model -> Session
toSession =
    Page.Home.Types.toSession


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , Firebase.inBoundPosts CompletedPostsLoad PortFailure
        ]
