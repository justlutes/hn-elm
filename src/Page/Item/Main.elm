module Page.Item.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Firebase as Firebase
import Html exposing (Html)
import Page.Item.Types exposing (..)
import Page.Item.View as View
import Session exposing (Session)


type alias Model =
    Page.Item.Types.Model


init : Session -> Int -> ( Model, Cmd Msg )
init session id =
    ( { session = session
      , feed = Loading
      }
    , Firebase.requestComments id
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
        , Firebase.inBoundPosts { onPosts = CompletedPostsLoad, onFailure = PortFailure }
        ]
