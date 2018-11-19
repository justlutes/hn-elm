module Data.Feed exposing (Model(..), Msg, decoder, init, update, viewPagination, viewPosts, viewTabs)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Page
import PaginatedList exposing (PaginatedList)
import Post exposing (Post)
import Route
import Session exposing (Session)
import Time



-- MODEL


type Model
    = Model Internals


type alias Internals =
    { session : Session
    , errors : List String
    , posts : PaginatedList Post
    , isLoading : Bool
    }


init : Session -> PaginatedList Post -> Model
init session posts =
    Model
        { session = session
        , errors = []
        , posts = posts
        , isLoading = False
        }



-- VIEW


viewPosts : Time.Zone -> Model -> List (Html Msg)
viewPosts timeZone (Model { posts, session, errors }) =
    let
        postsHtml =
            PaginatedList.values posts
                |> List.map (viewPost timeZone)
    in
    Page.viewErrors DismissErrors errors :: postsHtml


viewPost : Time.Zone -> Post -> Html msg
viewPost timeZone post =
    let
        { id, title, text, time } =
            Post.metadata post

        author =
            Post.author post
    in
    Html.div []
        [ Html.div []
            [ Html.div []
                [ Html.h1 []
                    [ case title of
                        Just title_ ->
                            Html.text title_

                        Nothing ->
                            Html.text ""
                    ]
                , Html.p []
                    [ case text of
                        Just text_ ->
                            Html.text text_

                        Nothing ->
                            Html.text ""
                    ]
                , Html.span [] [ Html.text "Read more..." ]
                ]
            ]
        ]


viewTabs :
    List ( String, msg )
    -> ( String, msg )
    -> List ( String, msg )
    -> Html msg
viewTabs before selected after =
    Html.ul [] <|
        List.concat
            [ List.map (viewTab []) before
            , [ viewTab [ Attributes.class "active" ] selected ]
            , List.map (viewTab []) after
            ]


viewTab : List (Html.Attribute msg) -> ( String, msg ) -> Html msg
viewTab attrs ( name, msg ) =
    Html.li []
        [ Html.a (Events.onClick msg :: Attributes.href "" :: attrs)
            [ Html.text name ]
        ]


viewPagination : (Int -> msg) -> Int -> Model -> Html msg
viewPagination toMsg page (Model feed) =
    let
        viewPageLink currentPage =
            pageLink toMsg currentPage (currentPage == page)

        totalPages =
            PaginatedList.total feed.posts
    in
    if totalPages > 1 then
        List.range 1 totalPages
            |> List.map viewPageLink
            |> Html.ul []

    else
        Html.text ""


pageLink : (Int -> msg) -> Int -> Bool -> Html msg
pageLink toMsg targetPage isActive =
    Html.li
        [ Attributes.classList
            [ ( "active", isActive ) ]
        ]
        [ Html.a
            [ Events.onClick (toMsg targetPage)
            , Attributes.href ""
            ]
            [ Html.text <| String.fromInt targetPage ]
        ]



-- UPDATE


type Msg
    = DismissErrors


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        DismissErrors ->
            ( Model { model | errors = [] }, Cmd.none )



-- SERIALIZATION


decoder : Int -> Decoder (PaginatedList Post)
decoder resultsPerPage =
    Decode.succeed PaginatedList.fromList
        |> required "postsCount" (pageCountDecoder resultsPerPage)
        |> required "posts" (Decode.list Post.postDecoder)


pageCountDecoder : Int -> Decoder Int
pageCountDecoder resultsPerPage =
    Decode.int
        |> Decode.map (\total -> ceiling (toFloat total / toFloat resultsPerPage))
