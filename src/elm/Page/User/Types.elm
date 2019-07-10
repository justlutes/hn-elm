module Page.User.Types exposing (Model, Msg(..), Status(..), toSession, update)

import Data.Firebase as Firebase
import Data.User exposing (User)
import Session exposing (Session)


type alias Model =
    { session : Session
    , user : Status User
    , userID : String
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
    | CompletedUserLoad User
    | PortFailure String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Initialize ->
            ( model, Firebase.requestUser model.userID )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        CompletedUserLoad user ->
            ( { model
                | user = Loaded user
              }
            , Cmd.none
            )

        PortFailure _ ->
            ( { model | user = Failed }
            , Cmd.none
            )


toSession : Model -> Session
toSession model =
    model.session
