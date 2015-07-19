'use strict';

var module = angular.module('fifteenPuzzleDirective', []);

module.directive('fifteenPuzzle', function(fifteenPuzzle) {
    return {
        restrict: 'EA',
        replace: true,
        template:
            '<table class="fifteen-puzzle" ng-class="{\'puzzle-solved\': puzzle.isSolved()}">' +
                '<tr ng-repeat="($row, row) in puzzle.grid">' +
                    '<td ng-repeat="($col, tile) in row" ng-click="puzzle.move($row, $col)" ng-style="tile.style" ng-class="{\'puzzle-empty\': tile.empty}" title="{{tile.id}}"></td>' +
                '</tr>' +
            '</table>',
        scope: {
            size: '@',
            src: '@',
            api: '='
        },
        link: function(scope, element, attrs) {
            var rows, cols,
                loading = true,
                image = new Image();

            function create() {
                scope.puzzle = fifteenPuzzle(rows, cols);

                if (attrs.api) {
                    scope.api = scope.puzzle;
                }

                tile();
            }

            function tile() {
                if (loading) {
                    return;
                }

                var width = image.width / cols,
                    height = image.height / rows;

                scope.puzzle.traverse(function(tile, row, col) {
                    tile.style = {
                        width: width + 'px',
                        height: height + 'px',
                        background: (tile.empty ? 'none' : "url('" + scope.src + "') no-repeat -" + (col * width) + 'px -' + (row * height) + 'px')
                    };
                });

                scope.puzzle.shuffle();
            }

            attrs.$observe('size', function(size) {
                size = size.split('x');
                if (size[0] >= 2 && size[1] >= 2) {
                    rows = size[0];
                    cols = size[1];
                    create();
                }
            });

            attrs.$observe('src', function(src) {
                loading = true;
                image.src = src;
                image.onload = function() {
                    loading = false;
                    scope.$apply(function() {
                        tile();
                    });
                };
            });
        }
    };
});
