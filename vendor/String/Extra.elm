module String.Extra exposing (pluralize)


pluralize : String -> String -> Int -> String
pluralize single plural count =
    if count == 1 then
        single

    else
        plural
