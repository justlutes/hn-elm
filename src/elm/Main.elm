module Main exposing (main)

import Api
import Browser exposing (Document)
import Browser.Navigation as Nav
import Data.Flags exposing (Flags)
import Firebase exposing (..)
import Html exposing (Html)
import Post exposing (Post)
import SelectList exposing (SelectList)
import Url exposing (Url)



-- MODEL


type alias Model =
    { posts : List Post
    , tabState : SelectList Category
    }


type Category
    = Top
    | New
    | Best


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( { posts = []
      , tabState =
            [ Top, Best ]
                |> SelectList.fromLists [] New
      }
    , Firebase.initialize "test"
    )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Hackernews in Elm"
    , body =
        [ Html.div [] [ Html.text "Hello world " ]
        ]
    }



-- UPDATE


type Msg
    = Ignored
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | InitComplete Model
    | ChangeTab Category
    | PostsReturn PortMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Ignored ->
            ( model, Cmd.none )

        InitComplete _ ->
            ( model, Cmd.none )

        ChangeTab category ->
            let
                newTabState =
                    SelectList.select
                        ((==) category)
                        model.tabState
            in
            ( { model | tabState = newTabState }, Cmd.none )

        PostsReturn _ ->
            ( { model | posts = [] }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    requestedPosts PostsReturn


main : Program Flags Model Msg
main =
    Api.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
