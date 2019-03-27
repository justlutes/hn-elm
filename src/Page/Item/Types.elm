module Page.Item.Types exposing (Model, Msg(..), Status(..), toSession, update)

import Browser.Dom as Dom
import Data.Comment as Comment exposing (Comment)
import Data.Firebase as Firebase
import Data.Post as Post exposing (Post)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Http
import Page
import Session exposing (Session)


type alias Model =
    { session : Session
    , comments : Status (List Comment)
    , postId : Int
    , parent : Status Post
    }


type Status a
    = Loading
    | LoadingSlowly
    | Loaded a
    | Failed


type Msg
    = NoOp
    | Initialize
    | GotSession Session
    | CompletedCommentsLoad ( Post, List Comment )
    | PortFailure String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        CompletedCommentsLoad ( post, comments ) ->
            ( { model
                | comments = Loaded comments
                , parent = Loaded post
              }
            , Cmd.none
            )

        Initialize ->
            ( model
            , Firebase.requestComments model.postId
            )

        PortFailure err ->
            ( { model | comments = Failed }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session
