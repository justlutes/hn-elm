module Page.Blank exposing (view)

import Html exposing (Html)
import Page exposing (PageLayout)


view : PageLayout
view =
    { title = ""
    , content = Html.text ""
    }
