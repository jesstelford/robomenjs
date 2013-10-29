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

  getFrame: -> return @frame

  paste: (x, y) ->
    # TODO: 'paste' this sprite to the screen so it is immune to future property
    # changes (but overwritten next game loop)

  play: (startFrame, endFrame, framesPerSecond) ->
    # TODO: Implement me
    # Use RequestAnimationFrame?
    # NOTE: DBPro seems to require this to be called every frame. I don't want
    # to do that, but I'm going to keep the code calling it every frame for now
  
  stop: ->
    # TODO: Stop animating (using cancelanimationframe?)
