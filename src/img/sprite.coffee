module.exports = class Sprite

  xPos: 0
  yPos: 0
  zIndex: 0
  frame: 0

  constructor: (@file, @across = 1, @down = 1) ->
    # TODO: Implement me
    console.log "New Sprite:", @file, @across, @down

    # TODO: call setRenderSize()

  render: ->
    # TODO: Implement me
    console.log "Rendering Sprite", @file

  setPosition: (@xPos, @yPos) ->

  setZIndex: (@zIndex) ->

  setRenderSize: (@renderWidth, @renderHeight) ->

  setRenderOffset: (@renderXOffset, @renderYOffset) ->

  setFrame: (@frame) ->

  paste: (x, y) ->
    # TODO: 'paste' this sprite to the screen so it is immune to future property
    # changes (but overwritten next game loop)
