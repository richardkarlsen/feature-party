port module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Table


---- MODEL ----


type alias Model =
    { features : List Feature
    , tableState : Table.State
    }


init : List Feature -> ( Model, Cmd Msg )
init features =
    let
        model =
            { features = features
            , tableState = Table.initialSort "Name"
            }
    in
        ( model, Cmd.none )



---- UPDATE ----


type Msg
    = SetTableState Table.State


port check : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )



---- VIEW ----


view : Model -> Html Msg
view { features, tableState } =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Feature Party!" ]
        , Table.view config tableState features
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init features
        , update = update
        , subscriptions = always Sub.none
        }


config : Table.Config Feature Msg
config =
    Table.config
        { toId = .name
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Name" .name
            , Table.stringColumn "dev" .name
            , Table.stringColumn "itest" .name
            , Table.stringColumn "stest" .name
            , Table.stringColumn "atest" .name
            , Table.stringColumn "prod" .name
            ]
        }



-- TODO Off On combine with state?


type alias Off =
    Bool


type alias On =
    Bool


type State
    = On
    | Off


type alias Environment =
    { name : String
    , state : State
    }


type alias Feature =
    { name : String
    , envirnoment : List Environment
    }


features : List Feature
features =
    [ Feature "feature-one"
        ([ Environment "dev" On
         , Environment "itest" On
         , Environment "stest" On
         , Environment "atest" On
         , Environment "prod" Off
         ]
        )
    , Feature "feature-two"
        ([ Environment "dev" On
         , Environment "itest" On
         , Environment "stest" On
         , Environment "atest" Off
         , Environment "prod" Off
         ]
        )
    ]
