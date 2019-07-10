module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Data.Flags exposing (Flags)
import Html
import Page
import Page.Ask.Main as Ask
import Page.Blank as Blank
import Page.Home.Main as Home
import Page.Item.Main as Item
import Page.Jobs.Main as Jobs
import Page.New.Main as New
import Page.NotFound as NotFound
import Page.Show.Main as Show
import Page.User.Main as User
import Route exposing (Route)
import Session as Session exposing (Session)
import Url exposing (Url)



-- MODEL


type Model
    = Home Home.Model
    | Item Item.Model
    | New New.Model
    | Show Show.Model
    | Ask Ask.Model
    | Jobs Jobs.Model
    | NotFound Session
    | Redirect Session
    | User User.Model


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer navKey))



-- VIEW


view : Model -> Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            viewPage Page.Other (\_ -> Ignored) Blank.view

        NotFound _ ->
            viewPage Page.Other (\_ -> Ignored) NotFound.view

        Home subModel ->
            viewPage Page.Home HomeMsg (Home.view subModel)

        Item subModel ->
            viewPage Page.Item ItemMsg (Item.view subModel)

        New subModel ->
            viewPage Page.New NewMsg (New.view subModel)

        Show subModel ->
            viewPage Page.Show ShowMsg (Show.view subModel)

        Ask subModel ->
            viewPage Page.Ask AskMsg (Ask.view subModel)

        Jobs subModel ->
            viewPage Page.Jobs JobsMsg (Jobs.view subModel)

        User subModel ->
            viewPage Page.User UserMsg (User.view subModel)



-- UPDATE


type Msg
    = Ignored
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | HomeMsg Home.Msg
    | ItemMsg Item.Msg
    | NewMsg New.Msg
    | ShowMsg Show.Msg
    | AskMsg Ask.Msg
    | JobsMsg Jobs.Msg
    | UserMsg User.Msg
    | GotSession Session


toSession : Model -> Session
toSession page =
    case page of
        Redirect session ->
            session

        NotFound session ->
            session

        Home subModel ->
            Home.toSession subModel

        Item subModel ->
            Item.toSession subModel

        New subModel ->
            New.toSession subModel

        Show subModel ->
            Show.toSession subModel

        Ask subModel ->
            Ask.toSession subModel

        Jobs subModel ->
            Jobs.toSession subModel

        User subModel ->
            User.toSession subModel


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
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
                |> updateWith Home HomeMsg

        Just Route.Ask ->
            Ask.init session
                |> updateWith Ask AskMsg

        Just Route.Show ->
            Show.init session
                |> updateWith Show ShowMsg

        Just Route.New ->
            New.init session
                |> updateWith New NewMsg

        Just Route.Jobs ->
            Jobs.init session
                |> updateWith Jobs JobsMsg

        Just (Route.Item id) ->
            Item.init session id
                |> updateWith Item ItemMsg

        Just (Route.User id) ->
            User.init session id
                |> updateWith User UserMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Ignored, _ ) ->
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

        ( GotSession session, Redirect _ ) ->
            ( Redirect session
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

        ( HomeMsg subMsg, Home subModel ) ->
            Home.update subMsg subModel
                |> updateWith Home HomeMsg

        ( ItemMsg subMsg, Item subModel ) ->
            Item.update subMsg subModel
                |> updateWith Item ItemMsg

        ( NewMsg subMsg, New subModel ) ->
            New.update subMsg subModel
                |> updateWith New NewMsg

        ( ShowMsg subMsg, Show subModel ) ->
            Show.update subMsg subModel
                |> updateWith Show ShowMsg

        ( AskMsg subMsg, Ask subModel ) ->
            Ask.update subMsg subModel
                |> updateWith Ask AskMsg

        ( JobsMsg subMsg, Jobs subModel ) ->
            Jobs.update subMsg subModel
                |> updateWith Jobs JobsMsg

        ( UserMsg subMsg, User subModel ) ->
            User.update subMsg subModel
                |> updateWith User UserMsg

        ( _, _ ) ->
            ( model, Cmd.none )


updateWith :
    (subModel -> Model)
    -> (subMsg -> Msg)
    -> ( subModel, Cmd subMsg )
    -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
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

        Home subModel ->
            Sub.map HomeMsg (Home.subscriptions subModel)

        Item subModel ->
            Sub.map ItemMsg (Item.subscriptions subModel)

        New subModel ->
            Sub.map NewMsg (New.subscriptions subModel)

        Show subModel ->
            Sub.map ShowMsg (Show.subscriptions subModel)

        Ask subModel ->
            Sub.map AskMsg (Ask.subscriptions subModel)

        Jobs subModel ->
            Sub.map JobsMsg (Jobs.subscriptions subModel)

        User subModel ->
            Sub.map UserMsg (User.subscriptions subModel)


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
