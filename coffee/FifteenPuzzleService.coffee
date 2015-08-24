"use strict"

fifteenPuzzleService = angular.module("fifteenPuzzleService", [])

fifteenPuzzleService.factory "fifteenPuzzle", ->

  shuffle = (a) ->
    q = undefined
    j = undefined
    x = undefined
    i = a.length

    while i
      q = 0
      j = parseInt(Math.random() * i, 10)
      x = a[--i]
      a[i] = a[j]
      a[j] = x
    a

  SlidingPuzzle = (rows, cols) ->
    @grid = []

    ###
    Moves tile
    @param srow
    @param scol
    ###
    @move = (srow, scol) ->
      dirs = [ [ 1, 0 ], [ -1, 0 ], [ 0, 1 ], [ 0, -1 ] ]
      tref = undefined
      trow = undefined
      tcol = undefined
      d = 0

      while d < dirs.length
        trow = srow + dirs[d][0]
        tcol = scol + dirs[d][1]

        if @grid[trow] and @grid[trow][tcol] and @grid[trow][tcol].empty
          tref = @grid[srow][scol]
          @grid[srow][scol] = @grid[trow][tcol]
          @grid[trow][tcol] = tref
        d++

    @shuffle = ->
      tiles = []
      @traverse (tile) ->
        tiles.push tile

      shuffle tiles
      @traverse (tile, row, col) ->
        @grid[row][col] = tiles.shift()


    @isSolved = ->
      id = 1
      row = 0
      while row < rows
        col = 0
        while col < cols
          return false  if @grid[row][col].id isnt id++
          col++
        row++
      true

    @traverse = (fn) ->
      row = 0
      while row < rows
        col = 0
        while col < cols
          fn.call this, (if @grid and @grid[row] then @grid[row][col] else undefined), row, col
          col++
        row++

    # initialize grid
    id = 1
    @traverse (tile, row, col) ->
      if !@grid[row]
        @grid[row] = []

      @grid[row][col] =
        id: id++
        empty: row == rows - 1 and col == cols - 1

      if @grid[row][col].empty
        @empty = @grid[row][col]
    return

  (rows, cols) ->
    new SlidingPuzzle(rows, cols)
