module Api exposing (application)

import Browser
import Browser.Navigation as Nav
import Data.Flags exposing (Flags)
import Url exposing (Url)



-- APPLICATION


application :
    { init : Flags -> Url -> Nav.Key -> ( model, Cmd msg )
    , onUrlChange : Url -> msg
    , onUrlRequest : Browser.UrlRequest -> msg
    , subscriptions : model -> Sub msg
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> Browser.Document msg
    }
    -> Program Flags model msg
application config =
    let
        init flags url navKey =
            config.init flags url navKey
    in
    Browser.application
        { init = init
        , onUrlChange = config.onUrlChange
        , onUrlRequest = config.onUrlRequest
        , subscriptions = config.subscriptions
        , update = config.update
        , view = config.view
        }
