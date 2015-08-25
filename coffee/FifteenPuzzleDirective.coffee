"use strict"

module = angular.module("fifteenPuzzleDirective", [])

module.directive "fifteenPuzzle", (fifteenPuzzle) ->
  restrict: "EA"
  replace: true
  template:
    '<table class="fifteen-puzzle" ng-class="{\'puzzle-solved\': puzzle.isSolved()}">' +
      '<tr ng-repeat="($row, row) in puzzle.grid">' +
        '<td ng-repeat="($col, tile) in row" ng-click="puzzle.move($row, $col)" ng-style="tile.style" ng-class="{\'puzzle-empty\': tile.empty}" title="{{tile.id}}"></td>' +
      '</tr>' +
    '</table>'
  scope:
    size: "@"
    src: "@"
    api: "="

  link: (scope, element, attrs) ->
    rows = undefined
    cols = undefined
    loading = true
    image = new Image()

    create = ->
      scope.puzzle = fifteenPuzzle(rows, cols)
      scope.api = scope.puzzle  if attrs.api
      tile()

    tile = ->
      return if loading
      width = image.width / cols
      height = image.height / rows
      scope.puzzle.traverse (tile, row, col) ->
        tile.style =
          width: width + "px"
          height: height + "px"
          background: ((if tile.empty then "none" else "url('" + scope.src + "') no-repeat -" + (col * width) + "px -" + (row * height) + "px"))
      scope.puzzle.shuffle()

    attrs.$observe "size", (size) ->
      size = size.split("x")
      if size[0] >= 2 and size[1] >= 2
        rows = size[0]
        cols = size[1]
        create()

    attrs.$observe "src", (src) ->
      loading = true
      image.src = src
      image.onload = ->
        loading = false
        scope.$apply ->
          tile()


