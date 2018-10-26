module Route exposing (Route(..), fromUrl, href, replaceUrl)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)
import Username exposing (Username)



-- ROUTES


type Route
    = Home
    | Root



-- | Login
-- | Logout


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top

        -- , Parser.map Login (s "login")
        -- , Parser.map Logout (s "logout")
        ]



-- HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser



-- PRIVATE HELPERS


routeToString : Route -> String
routeToString route =
    let
        pieces =
            case route of
                Home ->
                    []

                Root ->
                    []

        -- Login ->
        --     [ "login" ]
        -- Logout ->
        --     [ "logout" ]
    in
    "#/" ++ String.join "/" pieces
