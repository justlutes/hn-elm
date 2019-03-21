module Session exposing (Session, changes, fromViewer, navKey)

import Browser.Navigation as Nav


type alias Session =
    { entities : List Int
    , navKey : Nav.Key
    }


entities : Session -> List Int
entities session =
    session.entities


navKey : Session -> Nav.Key
navKey session =
    session.navKey


fromViewer : Nav.Key -> Session
fromViewer key =
    { entities = []
    , navKey = key
    }


changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Sub.none
