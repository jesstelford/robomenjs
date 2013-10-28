Playable = require('audio/playable')
module.exports = class Sound extends Playable
   loop: false

   play: ->
      # Ensure we only ever explicitly play once
      @loop = false
      Playable::play.apply this, arguments

   playLooped: ->
      @loop = true
      Playable::play.apply this, arguments

   stop: ->
      # Always revert to one-time playing for next time
      @loop = false
