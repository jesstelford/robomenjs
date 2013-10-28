Sprite = require('img/sprite')
Avatar = require('avatar')
Music = require('audio/music')
Sound = require('audio/sound')
levelLoader = require('level/loader')
looper = require('looper')
Q = require('q')
$ = global.jQuery

# Globals
SPLASH_TIMEOUT = 100
mapoffx = 95
mapoffy = 15
maptilesize = 30
avatardelay = 50
mouseselect = 0
totalavs = 0
av1num = 0
av2num = 0
currentlevel = 0
endanim = false
go = false
musicon = true
score = 0
totallevels = 24
ticktock = (new Date()).getTime()
trys = 0

fps = 0

tmp = 0

av = []
use = [0,0,0,0,0,0,0,0]
map = []
text = []
for i [1..15]
  map[i] = []
  tex[i] = []

spriteIdToSprite = []

exports.splash = ->

  deferred = Q.defer()

  splash = new Sprite "img/splash.png"
  splash.render()

  next = ->
    clearTimeout timeoutId
    $(document).off "keyup.splash mouseup.splash"
    deferred.resolve()
    console.log "Next"

  timeoutId = setTimeout next, SPLASH_TIMEOUT

  $(document).on "keyup.splash mouseup.splash", next

  return deferred.promise

exports.init = ->
  setupSprites()
  setupSounds()
  setupMusic()

exports.menu = ->
  $('#quit').on 'click.quit', ->
    # TODO: Quit
    $('#quit').off 'click.quit'

  $('#play').on 'click.play', ->
    # TODO: play
    $('#play').off 'click.play'

  $('#instructions').on 'click.instructions', ->
    # TODO: instructions
    $('#instructions').off 'click.instructions'

  $('#code').on 'click.code', ->
    # TODO: code
    $('#code').off 'click.code'

  $('#resume').on 'click.resume', ->
    # TODO: resume
    $('#resume').off 'click.resume'

exports.game = ->
  levelLoader.load 1

  looper.loop 60, (time, msPassed, framesPassed) ->


setupSprites = ->

  targetSprite = new Sprite "img/targetSprite.png", 19, 1
  targetSprite.setPosition -100, -100
  targetSprite.setZIndex 41
  targetSprite.setRenderSize 30, 30

  spriteIdToSprite[1] = targetSprite

  otherSprites = []

  for i in [2..8]
    otherSprites[i] = new Sprite "img/#{i}.png", 2, 1
    otherSprites[i].setPosition -100, -100
    otherSprites[i].setZIndex(i + 40)
    otherSprites[i].setRenderSize 30, 30
    spriteIdToSprite[i] = otherSprites[i]

  billySprite = new Sprite "img/billy.png", 8, 8
  billySprite.setPosition -100, -100
  billySprite.setZIndex 50
  billySprite.setRenderOffset 20, 30
  billySprite.setRenderSize 40, 40
  spriteIdToSprite[10] = billySprite

  redSprite = new Sprite "img/red.png", 8, 8
  redSprite.setPosition -100, -100
  redSprite.setZIndex 50
  redSprite.setRenderOffset 20, 30
  redSprite.setRenderSize 40, 40
  spriteIdToSprite[11] = redSprite

  grassSprite = new Sprite "img/grass.png", 5, 1
  grassSprite.setPosition -100, -100
  grassSprite.setZIndex 1
  grassSprite.setRenderSize 30, 30
  spriteIdToSprite[20] = grassSprite

  for i in [21..40]
    otherSprites[i] = new Sprite "img/#{i}.png"
    otherSprites[i].setPosition -100, -100
    otherSprites[i].setZIndex(i - 19)
    spriteIdToSprite[i] = otherSprites[i]

  goButtonSprite = new Sprite "img/go.png", 2, 1
  goButtonSprite.setRenderSize(loc[LOC_GO].x2 - loc[LOC_GO].x1, loc[LOC_GO].y2 - loc[LOC_GO].y1)
  goButtonSprite.setPosition -1000, -1000
  goButtonSprite.setZIndex 102
  spriteIdToSprite[106] = goButtonSprite

  resetSprite = new Sprite "img/reset.png",2,1
  resetSprite.setRenderSize(loc(LOC_RESET).x2 - loc(LOC_RESET).x1,loc(LOC_RESET).y2 - loc(LOC_RESET).y1)
  resetSprite.setPosition -1000,-1000
  resetSprite.setZIndex 102
  spriteIdToSprite[107] = resetSprite

  yellowHeadSprite = new Sprite "img/yellow-head.png",2,1
  yellowHeadSprite.setRenderSize 40,52
  yellowHeadSprite.setPosition -1000,-1000
  yellowHeadSprite.setZIndex 2
  spriteIdToSprite[109] = yelloHeadSprite

  redHeadSprite = new Sprite "img/red-head.png",2,1
  redHeadSprite.setRenderSize 40,52
  redHeadSprite.setPosition -1000,-1000
  redHeadSprite.setZIndex 2
  spriteIdToSprite[110] = redHeadSprite

setupSounds = ->

  droid3 = new Sound "audio/Droid 3.wav"
  hitWater = new Sound "audio/Hit water.wav"
  button2 = new Sound "audio/Button 2.wav"
  hitWall = new Sound "audio/Hit wall.wav"
  carpetFast = new Sound "audio/Carpet fast.wav"
  bug1 = new Sound "audio/Bug 1.wav"
  rippler = new Sound "audio/Rippler.wav"

  carpetFast.setVolume 50

setupMusic = ->

  fun = new Music "audio/music fun.mp3"
  fun.setVolume 50
  fun.play()
