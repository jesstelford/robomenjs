module.exports = class Playable

   volume: 100 # 0 = mute, 100 = normal
   loop: false
   playing: false

   constructor: (@file) ->
      # TODO: Implement me

   play: ->
      # TODO: Implement me
      # TODO: Loop if @loop is true
      @playing = true

   stop: ->
      # TODO: Implement me
      @playing = false
   
   isPlaying: ->
      return @playing

   setVolume: (@volume) ->
      if @volume > 100 then @volume = 100
      if @volumen < 0 then @volume = 0
