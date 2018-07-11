module Route exposing (Route(..), fromLocation, href, modifyUrl)

import Global
import Html
import Html.Attributes
import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = Settings
    | Plan
    | TokenRedirect String


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Nothing
    else
        parseHash route location


route : Parser (Route -> a) a
route =
    oneOf
        [ map TokenRedirect <| custom "ID TOKEN" Global.parseToken
        , map Settings <| s "settings"
        , map Plan <| s "plan"
        ]


modifyUrl : Route -> Cmd msg
modifyUrl =
    Navigation.modifyUrl << hash


href : Route -> Html.Attribute msg
href =
    Html.Attributes.href << hash


hash : Route -> String
hash route =
    case route of
        Settings ->
            "#/settings"

        Plan ->
            "#/plan"

        TokenRedirect _ ->
            "#/"