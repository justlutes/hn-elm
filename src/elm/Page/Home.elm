module Page.Home exposing (Model, Msg, toSession, view)

import Api exposing (Cred)
import Browser.Dom as Dom
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Http
import Page exposing (PageLayout)
import Session exposing (Session)
import Task exposing (Task)
import Url.Builder
import Username exposing (Username)



-- MODEL


type alias Model =
    { session : Session
    }



-- VIEW


view : Model -> PageLayout
view model =
    { title = "Hackernews Clone"
    , content =
        Html.div [] [ Html.text "Home Page " ]
    }



-- UPDATE


type Msg
    = GotSession Session
    | PassedSlowLoadThreshold


toSession : Model -> Session
toSession model =
    model.session
