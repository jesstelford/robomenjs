AnimationFrame = require('animationFrame')
# @params
# * frameRate: The frames per second to attempt to execute `doLoop`
# * doLoop: The function to execute. Should return falsey to cancel looping
# Will call `doLoop` with the following parameters:
# * time: The time the animation frame was requested
# * msPassed: The miliseconds passed since last called (will be 0 on first call)
# * framesPassed: The (fraction of) frames passed since last called (will be 0 on first call)
exports.loop = (frameRate, doLoop) ->
  animFrame = new AnimationFrame frameRate
  lastFrameTime = -1
  loopId = animFrame.request (time) ->

    msPassed = if lastFrameTime >= 0 then time - lastFrameTime else 0
    framesPassed = (msPassed / 1000) * frameRate
    lastFrameTime = time

    if not doLoop(time, msPassed, framesPassed)
      animFrame.cancel loopId 
