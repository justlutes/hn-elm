module Page.User.View exposing (view)

import Html exposing (Html)
import Page.User.Types exposing (Model, Msg)


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Profile - " ++ model.userID
    , content = Html.div [] []
    }
