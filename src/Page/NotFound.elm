module Page.NotFound exposing (view)

import Html exposing (Html)
import Html.Attributes as Attributes



-- VIEW


view : { title : String, content : Html msg }
view =
    { title = "Page Not Found"
    , content =
        Html.main_
            [ Attributes.id "content"
            , Attributes.class "container"
            , Attributes.tabindex -1
            ]
            [ Html.h1 [] [ Html.text "Not Found" ]
            , Html.div [ Attributes.class "row" ]
                []
            ]
    }
