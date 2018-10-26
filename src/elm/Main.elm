module Main exposing (main)

import Api exposing (Cred)
import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Json.Decode as Decode exposing (Value)
import Page
import Page.Blank as Blank
import Page.Home as Home
import Page.NotFound as NotFound
import Route exposing (Route)
import Session exposing (Session)
import Task
import Url exposing (Url)
import Username exposing (Username)
import Viewer exposing (Viewer)

type Model
    = Redirect Session
    | NotFound Session
    | Home Home.Model



-- | Comment Comment.Model
-- | Show Show.Model
-- | Ask Ask.Model
-- | Jobs Jobs.Model
-- MODEL


init : MaybeViewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url key =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer key maybeViewer))

-- VIEW
view : Model -> Html Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view (Session.viewer (toSession model)) page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            viewPage Page.Other (\_ -> NoOp) Blank.view

        NotFound _ ->
            viewPage Page.Other (\_ -> NoOp) NotFound.view

        Home home ->
            viewPage Page.Home GotHomeMsg (Home.view home)


-- UPDATE

type Msg
  = NoOp
  | ChangedRoute (Maybe Route)
  | ChangedUrl Url
  | ClickedLink Browser.UrlRequest
  | GotHomeMsg Home.Msg
  | GotSession Session

toSession : Model -> Session
toSession page =
  case page of
      Redirect session ->
          session

      NotFound session ->
          session

      Home home ->
        Home.toSession home

changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg)
changeRouteTo maybeRoute model =
  let
      session =
        toSession model
  in

  case maybeRoute of
      Nothing ->
          ( NotFound session, Cmd.none )

      Just Route.Root ->
          ( model, Route.replaceUrl (Session.navKey session) Route.Home )

      Just Route.Home ->
        Home.init session
          |> updateWith Home GotHomeMsg model

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( NoOp, _ ) ->
            ( model, Cmd.none )

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            ( model, Cmd.none )

                        Just _ ->
                            ( model
                            , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                            )

                Browser.External href ->
                    ( model, Nav.load href )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( ChangedRoute route, _ ) ->
            changeRouteTo route model

        ( GotSession session, Redirect _ ) ->
            ( Redirect session
            , Route.replaceUrl(Session.navKey session) Route.Home
            )

        ( _, _ ) ->
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
      NotFound _ ->
        Sub.none

        Redirect _ ->
          Session.changes GotSession (Session.navKey (toSession model))

        Home home ->
          Sub.map GotHomeMsg (Home.subscriptions home)




-- MAIN


main : Program Value Model Msg
main =
    Api.application Viewer.decoder
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
