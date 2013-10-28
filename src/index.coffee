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
# ticktock = Timer() #???
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

exports.game = ->
  levelLoader.load 1

setupSprites = ->

  target = new Sprite "img/target.png", 19, 1
  target.setPosition -100, -100
  target.setZIndex 41
  target.setRenderSize 30, 30

  otherSprites = []

  for i in [2..8]
    otherSprites[i] = new Sprite "img/#{i}.png", 2, 1
    otherSprites[i].setPosition -100, -100
    otherSprites[i].setZIndex(i + 40)
    otherSprites[i].setRenderSize 30, 30

  billy = new Sprite "img/billy.png", 8, 8
  billy.setPosition -100, -100
  billy.setZIndex 50
  billy.setRenderOffset 20, 30
  billy.setRenderSize 40, 40

  red = new Sprite "img/red.png", 8, 8
  red.setPosition -100, -100
  red.setZIndex 50
  red.setRenderOffset 20, 30
  red.setRenderSize 40, 40

  grass = new Sprite "img/grass.png", 5, 1
  grass.setPosition -100, -100
  grass.setZIndex 1
  grass.setRenderSize 30, 30

  for i in [21..40]
    otherSprites[i] = new Sprite "img/#{i}.png"
    otherSprites[i].setPosition -100, -100
    otherSprites[i].setZIndex(i - 19)

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
