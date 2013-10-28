file = require('fs/file')
Avatar = require('avatar')
_ = require('underscore')

exports.load = (newLevel) ->

  tmp = 0

  file = "levels/lvl#{newLevel}.gam"

  return false unless file.exists file

  # Clear out any existing avatars
  av.length = 0

  fileHandle = file.open file

  # Read the following 2-byte sequence:
  # Lives, CW, CCW, Reverse, up, down, right, left
  for i in [0..7]
    tmp = file.read fileHandle, 2
    if newLevel isnt currentlevel
      use[i] = tmp

  # TODO: Double check these aren't over by 1!
  for y in [1..10]
    for x in [1..15]
      tex[x][y] = file.read fileHandle, 2

      tmp = file.read fileHandle, 2
      if newLevel is currentlevel
        map[x][y] = tmp if (map[x][y] < 2) or (map[x][y] > 8)
      else
        map[x][y] = tmp

      if map[x][y] is 0 then map[x][y] = 20

      if map[x][y] < 10 or map[x][y] > 13
        continue

      avatar = new Avatar()

      avatar.kind = map[x][y]
      map[x][y] = 20
      avatar.xtile = x
      avatar.ytile = y
      avatar.x = ((x - 0.5) * maptilesize) + mapoffx
      avatar.y = ((y - 0.5) * maptilesize) + mapoffy
      avatar.speed = 1

      tmp = file.read fileHandle, 2

      switch tmp
        when 1
          avatar.ydir = -1
          avatar.nexty = y - 1
          avatar.nextx = x
          avatar.anim = 3
          avatar.animframe = 17
        when 2
          avatar.xdir = 1
          avatar.nexty = y
          avatar.nextx = x + 1
          avatar.anim = 4
          avatar.animframe = 25
        when 3
          avatar.ydir = 1
          avatar.nexty = y + 1
          avatar.nextx = x
          avatar.anim = 1
          avatar.animframe = 1
        when 4
          avatar.xdir = -1
          avatar.nexty = y
          avatar.nextx = x - 1
          avatar.anim = 2
          avatar.animframe = 9

      avatar.nextytile = avatar.nexty
      avatar.nextxtile = avatar.nextx

      if avatar.nexty > 10 then avatar.nextytile = 1
      if avatar.nexty < 1 then avatar.nextytile = 10
      if avatar.nextx > 15 then avatar.nextxtile = 1
      if avatar.nextx < 1 then avatar.nextxtile = 15

      av.push avatar


  file.close fileHandle

  totalavs = _.count(av)

  av1num = 0
  av2num = 0

  _(av).each (avatar) ->
    if avatar.kind is 10 then av1num++
    if avatar.kind is 11 then av2num++

  if newLevel isnt currentlevel
    ticktock = (new Date()).getTime()
    trys = 0

  currentlevel = newLevel
  go = 0

  return true
