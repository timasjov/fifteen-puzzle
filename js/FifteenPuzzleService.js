'use strict';

var fifteenPuzzleService = angular.module('fifteenPuzzleService', []);

fifteenPuzzleService.factory('fifteenPuzzle', function() {

    function shuffle(a) {
        var q;
        for (var j, x, i = a.length; i; j = parseInt(Math.random() * i, 10), x = a[--i], a[i] = a[j], a[j] = x) { q = 0; }
        return a;
    }

    function SlidingPuzzle(rows, cols) {

        this.grid = [];


        /**
         * Moves tile
         * @param srow
         * @param scol
         */
        this.move = function(srow, scol) {
            var dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]],
                tref, trow, tcol;

            for (var d = 0; d < dirs.length; d++) {
                trow = srow + dirs[d][0];
                tcol = scol + dirs[d][1];
                if (this.grid[trow] && this.grid[trow][tcol] && this.grid[trow][tcol].empty) {
                    tref = this.grid[srow][scol];
                    this.grid[srow][scol] = this.grid[trow][tcol];
                    this.grid[trow][tcol] = tref;
                }
            }
        };

        this.shuffle = function() {
            var tiles = [];
            this.traverse(function(tile) {
                tiles.push(tile);
            });
            shuffle(tiles);
            this.traverse(function(tile, row, col) {
                this.grid[row][col] = tiles.shift();
            });
        };


        this.isSolved = function() {
            var id = 1;
            for (var row = 0; row < rows; row++) {
                for (var col = 0; col < cols; col++) {
                    if (this.grid[row][col].id !== id++) {
                        return false;
                    }
                }
            }
            return true;
        };


        this.traverse = function(fn) {
            for (var row = 0; row < rows; row++) {
                for (var col = 0; col < cols; col++) {
                    fn.call(this, this.grid && this.grid[row] ? this.grid[row][col] : undefined, row, col);
                }
            }
        };

        // initialize grid
        var id = 1;
        this.traverse(function(tile, row, col) {
            if (!this.grid[row]) {
                this.grid[row] = [];
            }
            this.grid[row][col] = {
                id: id++,
                empty: (row === rows - 1) && (col === cols - 1)
            };
            if (this.grid[row][col].empty) {
                this.empty = this.grid[row][col];
            }
        });
    }

    return function(rows, cols) {
        return new SlidingPuzzle(rows, cols);
    };

});