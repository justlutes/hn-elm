module Page.Home exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Api exposing (Cred)
import Api.Endpoint as Endpoint
import Browser.Dom as Dom
import Data.Feed as Feed
import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, href, id, placeholder)
import Html.Events exposing (onClick)
import Http
import Loading
import Log
import Page
import PaginatedList exposing (PaginatedList)
import Session exposing (Session)
import Task exposing (Task)
import Time
import Url.Builder
import Username exposing (Username)



-- MODEL


type alias Model =
    { session : Session
    , timeZone : Time.Zone
    , feedTab : FeedTab
    , feedPage : Int

    -- Loaded independently from server
    , feed : Status Feed.Model
    }


type Status a
    = Loading
    | LoadingSlowly
    | Loaded a
    | Failed


type FeedTab
    = YourFeed Cred
    | GlobalFeed


init : Session -> ( Model, Cmd Msg )
init session =
    let
        feedTab =
            case Session.cred session of
                Just cred ->
                    YourFeed cred

                Nothing ->
                    GlobalFeed
    in
    ( { session = session
      , timeZone = Time.utc
      , feedTab = feedTab
      , feedPage = 1
      , feed = Loading
      }
    , Cmd.batch
        [ fetchFeed session feedTab 1
            |> Task.attempt CompletedFeedLoad
        , Task.perform GotTimeZone Time.here
        , Task.perform (\_ -> PassedSlowLoadThreshold) Loading.slowThreshold
        ]
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Conduit"
    , content =
        div [ class "home-page" ]
            [ viewBanner
            , div [ class "container page" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-9" ] <|
                        case model.feed of
                            Loaded feed ->
                                [ div [ class "feed-toggle" ] <|
                                    List.concat
                                        [ [ viewTabs
                                                (Session.cred model.session)
                                                model.feedTab
                                          ]
                                        , Feed.viewPosts model.timeZone feed
                                            |> List.map (Html.map GotFeedMsg)
                                        , [ Feed.viewPagination ClickedFeedPage model.feedPage feed ]
                                        ]
                                ]

                            Loading ->
                                []

                            LoadingSlowly ->
                                [ Loading.icon ]

                            Failed ->
                                [ Loading.error "feed" ]
                    ]
                ]
            ]
    }


viewBanner : Html msg
viewBanner =
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ] [ text "conduit" ]
            , p [] [ text "A place to share your knowledge." ]
            ]
        ]



-- TABS


viewTabs : Maybe Cred -> FeedTab -> Html Msg
viewTabs maybeCred tab =
    case tab of
        YourFeed cred ->
            Feed.viewTabs [] (yourFeed cred) [ globalFeed ]

        GlobalFeed ->
            let
                otherTabs =
                    case maybeCred of
                        Just cred ->
                            [ yourFeed cred ]

                        Nothing ->
                            []
            in
            Feed.viewTabs otherTabs globalFeed []


yourFeed : Cred -> ( String, Msg )
yourFeed cred =
    ( "Your Feed", ClickedTab (YourFeed cred) )


globalFeed : ( String, Msg )
globalFeed =
    ( "Global Feed", ClickedTab GlobalFeed )



-- UPDATE


type Msg
    = ClickedTab FeedTab
    | ClickedFeedPage Int
    | CompletedFeedLoad (Result Http.Error Feed.Model)
    | GotTimeZone Time.Zone
    | GotFeedMsg Feed.Msg
    | GotSession Session
    | PassedSlowLoadThreshold


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedTab tab ->
            ( { model | feedTab = tab }
            , fetchFeed model.session tab 1
                |> Task.attempt CompletedFeedLoad
            )

        ClickedFeedPage page ->
            ( { model | feedPage = page }
            , fetchFeed model.session model.feedTab page
                |> Task.andThen (\feed -> Task.map (\_ -> feed) scrollToTop)
                |> Task.attempt CompletedFeedLoad
            )

        CompletedFeedLoad (Ok feed) ->
            ( { model | feed = Loaded feed }, Cmd.none )

        CompletedFeedLoad (Err error) ->
            ( { model | feed = Failed }, Cmd.none )

        GotFeedMsg subMsg ->
            case model.feed of
                Loaded feed ->
                    let
                        ( newFeed, subCmd ) =
                            Feed.update subMsg feed
                    in
                    ( { model | feed = Loaded newFeed }
                    , Cmd.map GotFeedMsg subCmd
                    )

                Loading ->
                    ( model, Log.error )

                LoadingSlowly ->
                    ( model, Log.error )

                Failed ->
                    ( model, Log.error )

        GotTimeZone tz ->
            ( { model | timeZone = tz }, Cmd.none )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        PassedSlowLoadThreshold ->
            let
                -- If any data is still Loading, change it to LoadingSlowly
                -- so `view` knows to render a spinner.
                feed =
                    case model.feed of
                        Loading ->
                            LoadingSlowly

                        other ->
                            other
            in
            ( { model | feed = feed }, Cmd.none )



-- HTTP


fetchFeed : Session -> FeedTab -> Int -> Task Http.Error Feed.Model
fetchFeed session feedTabs page =
    let
        maybeCred =
            Session.cred session

        decoder =
            Feed.decoder articlesPerPage

        params =
            PaginatedList.params { page = page, resultsPerPage = articlesPerPage }

        request =
            case feedTabs of
                YourFeed cred ->
                    Api.get (Endpoint.feed params) maybeCred decoder

                GlobalFeed ->
                    -- Api.get (Endpoint.articles params) maybeCred decoder
                    Api.get (Endpoint.feed params) maybeCred decoder
    in
    Http.toTask request
        |> Task.map (Feed.init session)


articlesPerPage : Int
articlesPerPage =
    10


scrollToTop : Task x ()
scrollToTop =
    Dom.setViewport 0 0
        -- It's not worth showing the user anything special if scrolling fails.
        -- If anything, we'd log this to an error recording service.
        |> Task.onError (\_ -> Task.succeed ())



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
