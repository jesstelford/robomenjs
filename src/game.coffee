_ = require('underscore')
loader = require('level/loader')

_rotate_avatar = (avatar, CW) -> 

  #The resultant is -1 or 1
  dirChange = (1 + ((CW - 1) * 2))

  switch avatar.xdir
    when -1
      avatar.xdir = 0
      avatar.ydir = -1 * dirChange
    when 1
      avatar.xdir = 0
      avatar.ydir = 1 * dirChange
    else
      switch avatar.ydir
        when -1
          avatar.ydir = 0
          avatar.xdir = 1 * dirChange
        when 1
          avatar.ydir = 0
          avatar.xdir = -1 * dirChange

update_avatars = (scale) ->

  tmp1 = 0.0
  tmp2 = 0.0

  _(av).each (avatar) ->

    #Move them along on the screen
    avatar.x = avatar.x + (avatar.speed * avatar.xdir * scale)
    avatar.y = avatar.y + (avatar.speed * avatar.ydir * scale)

    tmp1 = ((avatar.nextx - 0.5) * maptilesize) + mapoffx
    tmp2 = ((avatar.nexty - 0.5) * maptilesize) + mapoffy

    #This check see's if the avatar has gone past the destination.
    #If so, Move them along on the tiles
    if ( (tmp1 - avatar.x) / Math.abs(tmp1 - avatar.x) isnt avatar.xdir ) or ( (tmp2 - avatar.y) / Math.abs(tmp2 - avatar.y) isnt avatar.ydir )
      #This only happens when the tiles change
      avatar.x = ((avatar.nextxtile - 0.5) * maptilesize) + mapoffx
      avatar.y = ((avatar.nextytile - 0.5) * maptilesize) + mapoffy

      #Checking for things such as user-drops, and the exit
      if map[avatar.nextxtile][avatar.nextytile] <= 8
        switch map(avatar.nextxtile,avatar.nextytile)
          when 1 #Win Condition
            avatar.dead = 1
            avatar.xdir = 0
            avatar.ydir = 0
            totalavs--
            endanim = 1
            if avatar.kind = 10 then av1num = av1num - 1
            if avatar.kind = 11 then av2num = av2num - 1
            if musicon then droid3.play()
          when 2 #Rotate CW
            _rotate_avatar avatar, 1

          when 3 #Rotate CCW
            _rotate_avatar avatar, 0
          when 4 #Reverse Direction
            avatar.xdir = avatar.xdir * -1
            avatar.ydir = avatar.ydir * -1
          when 5 #up arrow
            avatar.xdir = 0
            avatar.ydir = -1
          when 6 #down arrow
            avatar.xdir = 0
            avatar.ydir = 1
          when 7 #right arrow
            avatar.xdir = 1
            avatar.ydir = 0
          when 8 #left arrow
            avatar.xdir = -1
            avatar.ydir = 0

      avatar.xtile = avatar.nextxtile
      avatar.ytile = avatar.nextytile

      avatar.nextx = avatar.xtile + avatar.xdir
      avatar.nexty = avatar.ytile + avatar.ydir

      avatar.nextxtile = avatar.nextx
      avatar.nextytile = avatar.nexty

      if avatar.nexty > 10 then avatar.nextytile = 1
      if avatar.nexty < 1 then avatar.nextytile = 10
      if avatar.nextx > 15 then avatar.nextxtile = 1
      if avatar.nextx < 1 then avatar.nextxtile = 15

      # If the next map peice is impassable
      # Loop until we find a passable tile
      # TODO: Avoid infinite looping!
      while ( map[avatar.nextxtile][avatar.nextytile] >= 21 ) and ( map[avatar.nextxtile][avatar.nextytile] <= 27 )
        switch avatar.kind
          when 10
            _rotate_avatar(avatar, 1)
          when 11
            _rotate_avatar(avatar, 0)

        #reset the next tile values
        avatar.nextx = avatar.xtile + avatar.xdir
        avatar.nexty = avatar.ytile + avatar.ydir

        avatar.nextxtile = avatar.nextx
        avatar.nextytile = avatar.nexty

        if avatar.nexty > 10 then avatar.nextytile = 1
        if avatar.nexty < 1 then avatar.nextytile = 10
        if avatar.nextx > 15 then avatar.nextxtile = 1
        if avatar.nextx < 1 then avatar.nextxtile = 15


      #Falling into the water
      if ( map[avatar.nextxtile][avatar.nextytile] >= 28 ) and ( map[avatar.nextxtile][avatar.nextytile] <= 40 )
        if avatar.dying is 0 and avatar.dead is 0
          if ( ((tmp1 - 15) - avatar.x) / Math.abs((tmp1 - 15) - avatar.x) isnt avatar.xdir ) or ( ((tmp2 - 15) - avatar.y) / Math.abs((tmp2 - 15) - avatar.y) isnt avatar.ydir )
            #Just on the edge of the water
            avatar.dying = 1
            if musicon
              hitWater.play()
              carpetFast.stop()

      #Getting the right animation-set for the avatar
      switch avatar.xdir
        when -1
          avatar.anim = 2 + (4 * avatar.dying)
        when 1
          avatar.anim = 4 + (4 * avatar.dying)
        else
          switch avatar.ydir
            when -1
              avatar.anim = 3 + (4 * avatar.dying)
            when 1
              avatar.anim = 1 + (4 * avatar.dying)


_game_over = (str) ->

  buttonText = "Main Menu"

  console.log "Game Over!", str
  console.log "Score", score

  # TODO Define the 'main-menu' area (clicking anywhere goes back to the main menu)
  $('#main-menu').on 'click.main-menu', ->
    $('#main-menu').off 'click.main-menu'
    # TODO: Go back to the main menu

  # TODO: Define the 'game' area
  $('#game').on 'click.game', ->
    $('#game').off 'click.game'
    loader.load 1
    # TODO: Somehow get back to the game
   
_display = ->

  for y in [1..9]
    for x in [1..14]
      # TODO: Double check this frame isn't off by one (DBPro is 1-base indexed)
      spriteIdToSprite[20].setFrame(tex[x][y] - 1)
      # TODO: 'paste' this sprite onto the screen, so it's immune from future property changes
      spriteIdToSprite[20].paste(((x - 1) * maptilesize) + mapoffx, ((y - 1) * maptilesize) + mapoffy)
      # TODO: Double check this frame isn't off by one (DBPro is 1-base indexed)
      if ( map(x,y) > 1 ) and ( map(x,y) <= 8 ) then spriteIdToSprite[map[x][y]].setFrame 0
      if spriteIdToSprite[map[x][y]]? then spriteIdToSprite[map[x][y]].paste( ((x - 1) * maptilesize) + mapoffx,((y - 1) * maptilesize) + mapoffy)

  currentTime = (new Date()).getTime()

  _(av).each (avatar) ->
    if not avatar.dead
      if go
        if currentTime - avatar.timeout > avatardelay
          avatar.animframe = avatar.animframe + 1
          if ( avatar.animframe > (avatar.anim * 8) ) or ( avatar.animframe < ((avatar.anim - 1) * 8) + 1 )
            avatar.animframe = ((avatar.anim - 1) * 8) + 1
          avatar.timeout = currentTime
          if (avatar.animframe % 8 is 0) and (avatar.dying is 1)
            avatar.dying = 0
            avatar.dead = 1
            use[0] = use[0] - 1
            if use[0] = 0
              menus[MENU_ROW_1 ,MENU_RESUME].text = ""
              _game_over("You Lost All Your Lives")
            carpetFast.stop()
            loader.load currentlevel
            go = 0

      # TODO: Double check this frame isn't off by one (DBPro is 1-base indexed)
      spriteIdToSprite[avatar.kind].setFrame(avatar.animframe - 1)
      spriteIdToSprite[avatar.kind].paste Math.floor(avatar.x), Math.floor(avatar.y)


_game_interface = ->

  #The Visuals of the characters remaining
  if av1num = 0 then spriteIdToSprite[109].setFrame 2 else spriteIdToSprite[109].setFrame 1
  if av2num = 0 then spriteIdToSprite[110].setFrame 2 else spriteIdToSprite[110].setFrame 1
  spriteIdToSprite[109].paste 116,363
  spriteIdToSprite[110].paste 162,363
  
  #Sprites for click and drag peices.
  for i in [2..8]
    if use[i-1] is 0 then spriteIdToSprite[i].setFrame 2 else spriteIdToSprite[i].setFrame 1
    spriteIdToSprite[i].paste((i-2)*30 + 215, 385)

  #Go and Reset buttons
  spriteIdToSprite[106].paste(loc[LOC_GO].x1,loc[LOC_GO].y1)
  spriteIdToSprite[107].paste(loc[LOC_RESET].x1,loc[LOC_RESET].y1)

_inzone = (x1,y1,x2,y2,x,y) ->
  if x >= x1 and x <= x2 and y >= y1 and y <= y2 then return 1
  return 0

_score = (attempts, time) ->
  #time in seconds

  cont = false
  pressed = false
  active = false
  button = ""
  code = ""

  code = codes[currentlevel]

  attemptBonus = Math.floor(1000 / attempts)
  timeBonus = Math.floor(10000 / time)

  score += attemptBonus
  score += timeBonus

  button = "Next Level"

  $(document).on '#game', 'click.score' =>
    cont = 1
    pressed = 0

  $(document).on '#game', 'mouseover.score' =>
    active = 1

  $(document).on '#game', 'mouseout.score' =>
    active = 0

  console.log "Copmleted!"
  console.log "Code:", code

  console.log "Time Taken:", time, "seconds"
  console.log "Attempts Made:", attempts
  console.log "Time Bonus:", timeBonus
  console.log "Attempt Bonus:", attemptBonus
  console.log "Level Score:", timeBonus, "+", attemptBonus, "=", timeBonus + attemptBonus
  console.log "Score:", score
  console.log "Level:", currentlevel

  # TODO: Delay execution somehow and return -1 once done

exports.game = (time, msPassed, framesPassed) ->

  if go = 1 then update_avatars(framesPassed)

  _display()

  _game_interface()

  # TODO Take this and all other event registrations out of the loop!
  $(document).on '#go', 'mousedown.go', ->
    if go = 0
      trys = trys + 1
      go = 1
      if musicon
        rippler.play()
        carpetFast.playLooped()

  $(document).on '#reset', 'mousedown.reset', ->
    if go = 1
      go = 0
      if musicon
        bug1.play()
        carpetFast.stop()
      loader.load currentlevel

  $(document).on '.item', 'mousedown.item', ->
    if not go
      #TODO: Set the .data('item-type') property for each item in the UI
      mouseselect = $(@).data('item-type')
      if use[mouseselect - 1] is 0 then mouseselect = 0

  $(document).on 'mousedown.no-select-items', ->
    # TODO: If the user isn't clicking within the 'items' area, reset mouseselect
    if not go and not _inzone()
      mouseselect = 0

  $(document).on '.item-placed', 'mousedown.item-placed', ->
    if not go
      itemType = $(@).data('item-type')
      # TODO: Set the data attributes when this item is placed in the game field
      tileX = $(@).data('tileX')
      tileY = $(@).data('tileY')
      # TODO: Add one back into the UI for this item
      use[itemType - 1]++ # Add one back to the count available
      map[tileX][tileY] = 20 # Reset that map peice to grass
      if musicon then button2.play()

  $(document).on "#menu_#{MENU_RESUME}", "mousedown.menu_#{MENU_RESUME}", ->
    # Go to the menu (and stop the game loop somehow)

  $(document).on "#menu_#{MENU_INSTRUCTIONS}", "mousedown.menu_#{MENU_INSTRUCTIONS}", ->
    # Go to the instructions (and stop the game loop somehow)

  $(document).on "#menu_#{MENU_AUDIO}", "mousedown.menu_#{MENU_AUDIO}", ->
    # Go to the instructions (and stop the game loop somehow)
    if musicon
      musicon = 0
      fun.stop()
      carpetFast.stop()
    else
      musicon = 1
      fun.play()

  $(document).on "mouseup.gameloop", ->
    spriteIdToSprite[106].setFrame 1
    spriteIdToSprite[107].setFrame 1

    # TODO get Mouse position
    mouseX = 0
    mouseY = 0

    #What to do when an item is dropped
    if mouseselect isnt 0
      if _inzone(loc[LOC_GAME_AREA].x1, loc[LOC_GAME_AREA].y1, loc[LOC_GAME_AREA].x2, loc[LOC_GAME_AREA].y2, mouseX, mouseY)
        tmpx = Math.floor((mouseX - mapoffx)/30) + 1
        tmpy = Math.floor((mouseY - mapoffy)/30) + 1
        if ( map[tmpx][tmpy] <= 20 ) and ( map[tmpx][tmpy] isnt 1 )
          map[tmpx][tmpy] = mouseselect
          use[mouseselect - 1]--
          if musicon then hitWal.play()
      mouseselect = 0

  # TODO: 
  # Paste the sprite at the position of the mouse while mouseselect isnt 0
  # If mouseselect <> 0 Then Paste Sprite mouseselect,MouseX() - Sprite Width(mouseselect)/2,MouseY() - Sprite Height(mouseselect)/2

  if endanim is 1
    spriteIdToSprite[1].play 1, 19, 20 # target sprite
    if spriteIdToSprite[1].getFrame is 19 then endanim = 0

  if totalavs is 0 and endanim is 0
     go = 0
     carpetFast.stop()

     _score(trys, Math.floor(((new Date()).getTime() - ticktock)/1000))
     if not loader.exists(currentlevel + 1)
        # Final Win Condition!
        _game_over("You Completed All The Available Levels!")
        # TODO: Go to the main menu

  #In-game Menu items...
  console.log "Lives:", use[0]
  console.log "Level:", currentlevel


  for i in [1..7]
    if use[i] is 0
      console.log "Item #{i} is out!"
    else
      console.log "Item #{i} remaining:", use[i]

  if av1num = 0
    console.log "Avatar 1 is out!"
  else
    console.log "Avatar 1 remaining:", av1num

  if av2num = 0
    console.log "Avatar 2 is out!"
  else
    console.log "Avatar 2 remaining:", av2num
