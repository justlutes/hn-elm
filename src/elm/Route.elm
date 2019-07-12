module Route exposing (Route(..), fromUrl, href, replaceUrl)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Builder as Builder
import Url.Parser as Parser exposing ((</>), Parser, int, oneOf, s, string)


type Route
    = Home
    | Root
    | New
    | Show
    | Ask
    | Jobs
    | Item Int
    | User String


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map New (s "new")
        , Parser.map Show (s "show")
        , Parser.map Ask (s "ask")
        , Parser.map Jobs (s "jobs")
        , Parser.map Item (s "item" </> int)
        , Parser.map User (s "user" </> string)
        ]



-- PUBLIC HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url



-- PRIVATE HELPERS


routeToString : Route -> String
routeToString route =
    let
        ( pathPieces, queryPieces ) =
            case route of
                Home ->
                    ( [], [] )

                Root ->
                    ( [], [] )

                New ->
                    ( [ "new" ], [] )

                Show ->
                    ( [ "show" ], [] )

                Ask ->
                    ( [ "ask" ], [] )

                Jobs ->
                    ( [ "jobs" ], [] )

                Item id ->
                    ( [ "item", String.fromInt id ], [] )

                User id ->
                    ( [ "user", id ], [] )
    in
    -- "#/" ++ String.join "/" pieces
    Builder.absolute pathPieces queryPieces
