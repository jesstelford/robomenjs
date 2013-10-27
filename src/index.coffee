Sprite = require('img/sprite')
Q = require('q')
$ = jQuery

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

exports.splash = ->

  deferred = Q.defer()

  splash = new Sprite('media/RoboMenSplash.png')
  splash.render()

  next = ->
    clearTimeout timeoutId
    $(document).off 'keyup.splash mouseup.splash'
    deferred.resolve()
    console.log "Next"

  timeoutId = setTimeout next, SPLASH_TIMEOUT

  $(document).on 'keyup.splash mouseup.splash', next

  return deferred.promise
