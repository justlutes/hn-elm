module Page.NotFound exposing (view)

import Html exposing (Html)
import Html.Attributes as Attributes
import Page exposing (PageLayout)


view : PageLayout
view =
    { title = "Page Not Found"
    , content =
        Html.main_ [ Attributes.id "content", Attributes.tabindex -1 ]
            [ Html.h1 [] [ Html.text "Not Found" ]
            ]
    }
