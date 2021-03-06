module Example where

import Window
import String

import Html exposing (Html, div)
import Html.Attributes exposing (style)

import PrettyPrint as PP exposing (..)
import PrettyPrint.Util exposing (..)

type Tree =
  Node String (List Tree)

showTree tree =
  case tree of
    Node s ts ->
      group (text [] s `concat` nest (String.length s) (showBracket ts))

showBracket trees =
  case trees of
    [] ->
      empty

    ts ->
      text [] "[" `concat` nest 1 (showTrees ts) `concat` text [] "]"


showTrees trees =
  case trees of
    [] ->
      empty

    [t] ->
      showTree t

    t :: ts ->
      showTree t `concat` text [] "," `concat` line `concat` showTrees ts

showTree' node =
  case node of
    Node s ts ->
      text [] s `concat` showBracket' ts

showBracket' ts =
  case ts of
    [] ->
      empty

    ts ->
      bracket 2 ([], "[") (showTrees' ts) ([], "]")


showTrees' trees =
  case trees of
    [] ->
      empty

    [t] ->
      showTree t

    t :: ts ->
      showTree t `concat` text [] "," `concat` line `concat` showTrees ts


-- render

exampleTree =
  Node "aaaaaaaaaaaaaaaaaa" [
    Node "bbbbbbbbbbbbbbbbbbbbbbbb" [
      Node "ccccccccccccccccccccccccccccccccccccccccccccc" [],
      Node "dddddddddddddddddddddddddddddddddddddddddddddddddddddddd" []
    ],
    Node "eeeee" []
  ]


render : Doc -> (Int, Int) -> Html
render doc (width, height) =
  div
    [ style [("font-size", "12px")] ]
    [ prettyHtml (round (toFloat width / 7.3)) doc ] -- experimentally determined width of char...


exampleDoc =
  let
    doc =
      --Debug.log "doc" <|
      (bracket 2 ([], "[") (text [] "foo") ([], "]"))
  in
    doc


main : Signal Html
main =
  Signal.map
    (render (showTree exampleTree))
    --(render exampleDoc)
    Window.dimensions
