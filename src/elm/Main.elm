module Main exposing (main)


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

-- UPDATE

type Msg
  = Ignored
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
