module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onCheck)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Model

type alias Task = {name: String, assignee: String, done: Bool}

type alias Model =
    { tasks: List Task
    , editing: Task}

emptyTask : Task
emptyTask = {name = "", assignee = "", done = False}

init : ( Model, Cmd Msg )
init =
    Model [] emptyTask ! []



-- Update


type Msg
    = AddTask
    | UpdateTaskField String
    | UpdateAssigneeField String
    | ToggleDoneCheck Int Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let current = model.editing in
    case msg of
        AddTask ->
            {model | tasks = model.editing::model.tasks, editing = emptyTask } ! []
        (UpdateTaskField task) ->
            {model | editing = {current | name = task }} ! []
        (UpdateAssigneeField assignee) ->
            {model | editing = {current | assignee = assignee }} ! []
        (ToggleDoneCheck target done) ->
            let newTasks = List.indexedMap (toggle done target) model.tasks in
            {model | tasks = newTasks} ! []

toggle : Bool -> Int -> Int -> Task -> Task
toggle done target idx task = case (target == idx) of
    True -> {task | done = done}
    False -> task

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

viewTask : String -> String -> List (Html Msg)
viewTask name assignee = [strong [] [text name], text " Assigned to: ", strong [] [text assignee]]

viewTasks : List Task -> List (Html Msg)
viewTasks tasks = List.indexedMap (\idx {name, assignee, done} -> li (if done then [class "done_class"] else [])
        ((viewTask name assignee) ++ [input [type_ "checkbox", onCheck (ToggleDoneCheck idx)] []] )
    ) tasks

isFormReady : Task -> Bool
isFormReady {name, assignee} = not (String.isEmpty name) && not (String.isEmpty assignee)

displayIf : Bool -> Attribute Msg
displayIf flag = case flag of
    False -> style [("display", "none")]
    True -> style []

count : List Task -> String
count tasks = let doneCount = List.length (List.filter (\t -> t.done) tasks)
                  totalCount = List.length tasks
              in toString doneCount ++ "/" ++ toString totalCount


view : Model -> Html Msg
view {tasks, editing} =
    div [] [
         stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
       , stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
       , stylesheet "main.css"
       , div [class "container"] [
             h1 [] [text "Todo App"]
           , div [class "row"] [
                 div [class "col-md-6"] [
                       h2 [] [text ("Tasks " ++ count tasks )]
                     , ul [] (viewTasks tasks)
                 ]
               , div [class "col-md-6"]
                   ((div [class "form-group"] [
                         h2 [] [text "Add new tasks"]
                       , input [type_ "text", placeholder "Task", onInput UpdateTaskField, value editing.name] []
                       , input [type_ "text", placeholder "Assignee", onInput UpdateAssigneeField, value editing.assignee] []
                       , button [class "btn", onClick AddTask, displayIf (isFormReady editing)] [text "Add"]
                   ]) :: viewTask editing.name editing.assignee)
           ]
       ]
    ]
