module Page.Home.Types exposing (Model, Msg(..), toSession)

import Browser.Dom as Dom
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Page
import Session exposing (Session)


type alias Model =
    { session : Session
    }


type Msg
    = NoOp
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )


toSession : Model -> Session
toSession model =
    model.session
