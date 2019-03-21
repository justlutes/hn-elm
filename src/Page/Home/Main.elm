module Page.Home.Main exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html)
import Page.Home.Types exposing (..)
import Page.Home.View as View
import Session exposing (Session)


type alias Model =
    Page.Home.Types.Model


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session }
    , Cmd.none
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
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )


toSession : Model -> Session
toSession =
    Page.Home.Types.toSession


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
