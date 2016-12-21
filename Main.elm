module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Model


type alias Model =
    { name : String }


init : ( Model, Cmd Msg )
init =
    Model "world" ! []



-- Update


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []



-- View

stylesheet url =
    let
        tag = "link"
        attrs =
            [ attribute "rel"       "stylesheet"
            , attribute "property"  "stylesheet"
            , attribute "href"      url
            ]
        children = []
    in
        node tag attrs children

viewTasks : Model -> List (Html Msg)
viewTasks _ = []

view : Model -> Html Msg
view model =
    div [] [
         stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
       , stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
       , stylesheet "main.css"
       , div [class "container"] [
             h1 [] [text "Todo App"]
           , div [class "row"] [
                 div [class "col-md-6"] [
                       h2 [] [text "Tasks"]
                     , ul [] (viewTasks model)
                 ]
               , div [class "col-md-6"] [
                   div [class "form-group"] [
                         h2 [] [text "Add new tasks"]
                       , input [type_ "text", placeholder "Task"] []
                       , input [type_ "text", placeholder "Assignee"] []
                       , button [class "btn"] [text "Add"]
                   ]
               ]
           ]
       ]
    ]
