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

  #Left-Mouse-Click stuffskies
  If MouseClick() = 1 : If lmb = 0 : lmb = 1
  #** On KeyDown **

  #** End On Down **
  Else
  #** While KeyHeld **

     #Some image swapping for the Buttons on the Interface
     If _dist(MouseX(),MouseY(),590,53) <= 10
        Set Sprite Image 102,104
     Else
        Set Sprite Image 102,102
        If _dist(MouseX(),MouseY(),566,37) <= 10
           Set Sprite Image 101,105
        Else
           Set Sprite Image 101,103
        EndIf
     EndIf

     If _inzone(loc[LOC_GO].x1,loc[LOC_GO].y1,loc[LOC_GO].x2,loc[LOC_GO].y2,MouseX(),MouseY())
        Set Sprite Frame 106,2
     Else
        Set Sprite Frame 106,1
     EndIf

     If _inzone(loc[LOC_RESET].x1,loc[LOC_RESET].y1,loc[LOC_RESET].x2,loc[LOC_RESET].y2,MouseX(),MouseY())
        Set Sprite Frame 107,2
     Else
        Set Sprite Frame 107,1
     EndIf

     If mouseselect <> 0 Then Paste Sprite mouseselect,MouseX() - Sprite Width(mouseselect)/2,MouseY() - Sprite Height(mouseselect)/2


     If _inzone(loc[LOC_MENU].x1,loc[LOC_MENU].y1,loc[LOC_MENU].x2,loc[LOC_MENU].y2,MouseX(),MouseY())
        For i = 6 To 8
           If _inzone(loc(i).x1,loc(i).y1,loc(i).x2,loc(i).y2,MouseX(),MouseY())
              menus(MENU_ROW_0,i - 6).pressed = 1
           Else
              menus(MENU_ROW_0,i - 6).pressed = 0
           EndIf
        Next i
     Else
        For i = 0 To 2
           menus(MENU_ROW_0,i).pressed = 0
        Next i
     EndIf


  #** End Held **
  EndIf : Else : If lmb = 1 : lmb = 0
  #** On KeyUp **

     If _dist(MouseX(),MouseY(),590,53) <= 10
        Set Sprite Image 102,102
        End
     EndIf

     If _dist(MouseX(),MouseY(),566,37) <= 10
        Set Sprite Image 101,103
        Minimize Window
     EndIf

     Set Sprite Frame 106,1
     Set Sprite Frame 107,1

     #What to do when an item is dropped
     If mouseselect <> 0
        If _inzone(loc[LOC_GAME_AREA].x1,loc[LOC_GAME_AREA].y1,loc[LOC_GAME_AREA].x2,loc[LOC_GAME_AREA].y2,MouseX(),MouseY())
           tmpx = Int((MouseX() - mapoffx)/30) + 1
           tmpy = Int((MouseY() - mapoffy)/30) + 1
           If ( map(tmpx,tmpy) <= 20 ) AND ( map(tmpx,tmpy) <> 1 )
              map(tmpx,tmpy) = mouseselect
              use(mouseselect - 1) = use(mouseselect - 1) - 1
              If musicon Then Play Sound SOUND_HIT_WALL
           EndIf
        EndIf
        mouseselect = 0
     EndIf

     If menus(MENU_ROW_0, MENU_MENU).pressed = 1
        #Menu
        menus(MENU_ROW_0, MENU_MENU).pressed = 0
        menus(MENU_ROW_1,MENU_RESUME).text = menus(MENU_ROW_1,MENU_RESUME).text2
        If _main_menu() = -1
           _load_level(1)
           GoTo start
        EndIf
     EndIf

     If menus(MENU_ROW_0,MENU_INSTRUCTIONS).pressed = 1
        #Instructions
        menus(MENU_ROW_0,MENU_INSTRUCTIONS).pressed = 0
        menus(MENU_ROW_1,MENU_RESUME).text = menus(MENU_ROW_1,MENU_RESUME).text2
        If _instructions(1) = -1
           _load_level(1)
           GoTo start
        EndIf
     EndIf

     If menus(MENU_ROW_0,MENU_AUDIO).pressed = 1
        #Audio On/Off
        If menus(MENU_ROW_0,MENU_AUDIO).text = menus(MENU_ROW_0,MENU_AUDIO).text1 Then menus(MENU_ROW_0,MENU_AUDIO).text = menus(MENU_ROW_0,MENU_AUDIO).text2 Else menus(MENU_ROW_0,MENU_AUDIO).text = menus(MENU_ROW_0,MENU_AUDIO).text1
        menus(MENU_ROW_0,MENU_AUDIO).pressed = 0
        If musicon
           musicon = 0
           Stop Music MUSIC_FUN
           Stop Sound SOUND_CARPET_FAST
        Else
           musicon = 1
           Loop Music MUSIC_FUN
        EndIf
     EndIf

  #** End On Up **
  EndIf : EndIf

  If endanim = 1
     Play Sprite 1,1,19,20
     If Sprite Frame(1) = 19 Then endanim = 0
  EndIf

  If totalavs = 0 And endanim = 0
     go = 0
     Stop Sound SOUND_CARPET_FAST
     _score(trys, Int((Timer() - ticktock)/1000))
     If _load_level(currentlevel + 1) = -1
        #Final Win Condition!
        _game_over("You Completed All The Available Levels!")
        If _main_menu() = -1
           _load_level(1)
           GoTo start
        EndIf
     EndIf
  EndIf

  If _inzone(loc[LOC_MENU].x1,loc[LOC_MENU].y1,loc[LOC_MENU].x2,loc[LOC_MENU].y2,MouseX(),MouseY())
     For i = 6 To 8
        If menus(MENU_ROW_0,i - 6).pressed = 0
           If _inzone(loc(i).x1,loc(i).y1,loc(i).x2,loc(i).y2,MouseX(),MouseY())
              menus(MENU_ROW_0,i - 6).active = 1
           Else
              menus(MENU_ROW_0,i - 6).active = 0
           EndIf
        EndIf
     Next i
  Else
     For i = 0 To 2
        menus(MENU_ROW_0,i).active = 0
     Next i
  EndIf


  #In-game Menu items...
  StartText

  Draw Color 0,150,50,100
  For i = 0 To 2
     Text AA 1,482,350 + (i*30),1,menus(MENU_ROW_0,i).text
  Next i
  Text AA 1,221,351,0,"Lives: " + Str$(use(0))  :#Lives meter
  Text AA 1,351,351,0,"Level: " + Str$(currentlevel)  :#Level

  Draw Color 0,100,0,25
  For i = 0 To 2
     If menus(MENU_ROW_0,i).pressed = 1
        Text AA 1,481,349 + (i*30),1,menus(MENU_ROW_0,i).text
     Else
        If menus(MENU_ROW_0,i).active
           Text AA 1,484,352 + (i*30),1,menus(MENU_ROW_0,i).text
        Else
           Text AA 1,483,351 + (i*30),1,menus(MENU_ROW_0,i).text
        EndIf
     EndIf
  Next i
  Text AA 1,222,352,0,"Lives: " + Str$(use(0))  :#Lives meter
  Text AA 1,352,352,0,"Level: " + Str$(currentlevel)  :#Level

  Draw Color 100,200,100,35
  For i = 0 To 2
     If menus(MENU_ROW_0,i).pressed = 1
        Text AA 1,483,351 + (i*30),1,menus(MENU_ROW_0,i).text
     Else
        If menus(MENU_ROW_0,i).active
           Text AA 1,480,348 + (i*30),1,menus(MENU_ROW_0,i).text
        Else
           Text AA 1,481,349 + (i*30),1,menus(MENU_ROW_0,i).text
        EndIf
     EndIf
  Next i
  Text AA 1,220,350,0,"Lives: " + Str$(use(0))  :#Lives meter
  Text AA 1,350,350,0,"Level: " + Str$(currentlevel)  :#Level

  Text AA 1,500,440,1,"FPS = " + Str$(fps)

  For i = 1 To 7
     If use(i) = 0
        Draw Color 0,150,50,25
        Text AA 2,200 + (i * 30),410,1,Str$(use(i))
        Draw Color 0,150,50,100
     Else
        Text AA 2,200 + (i * 30),410,1,Str$(use(i))
     EndIf
  Next i

  If av1num = 0
     Draw Color 0,150,50,25
     Text AA 2,136,410,1,"0"
     Draw Color 0,150,50,100
  Else
     Text AA 2,136,410,1,Str$(av1num)
  EndIf

  If av2num = 0
     Draw Color 0,150,50,25
     Text AA 2,182,410,1,"0"
     Draw Color 0,150,50,100
  Else
     Text AA 2,182,410,1,Str$(av2num)
  EndIf

  EndText
