class animation_controller
    @setup: ->
        console.log("animation_controller setup")
        #setup stage
        animation_controller.stage1 = new Kinetic.Stage(
            container: "u_canvas_container"
            width: 200
            height: 200
            scale:1
        )

        animation_controller.stage2 = new Kinetic.Stage(
            container: "e_canvas_container"
            width: 200
            height: 200
            scale:1
        )

        animation_controller.u_layer = new Kinetic.Layer()
        animation_controller.e_layer = new Kinetic.Layer()

        animation_controller.sprite_sheet1 = new Image()
        animation_controller.sprite_sheet1.onload = ->
            #generate the sprite objects
            animation_controller.u_sprite = animation_controller.generate_sprite( animation_controller.generate_animations(), 1 )
            #add them to the layers
            animation_controller.u_layer.add(animation_controller.u_sprite)
            #add the layers to the stage
            animation_controller.stage1.add(animation_controller.u_layer)
            #start sprite
            animation_controller.u_sprite.start()
        animation_controller.sprite_sheet1.src = "/warrior_sprite1.png"

        animation_controller.sprite_sheet2 = new Image()
        animation_controller.sprite_sheet2.onload = ->
            #generate the sprite objects
            animation_controller.e_sprite = animation_controller.generate_sprite( animation_controller.generate_animations(), 2 )
            #add them to the layers
            animation_controller.e_layer.add(animation_controller.e_sprite)
            #add the layers to the stage
            animation_controller.stage2.add(animation_controller.e_layer)
            #start sprite
            animation_controller.e_sprite.start()
        animation_controller.sprite_sheet2.src = "/warrior_sprite2.png"



    ###
    SPRITE STUFF
    ###
    @generate_sprite: (animation, sprite, framerate=5) ->
        sprite_sheet =  if sprite == 1 then animation_controller.sprite_sheet1 else animation_controller.sprite_sheet2
        #helper that generates the sprite object with default params
        new Kinetic.Sprite(
            x: 0
            y: 0
            animation: 'waiting'
            animations: animation
            image: sprite_sheet
            frameRate: framerate
        )

    #generate the animation obj for the message sprite
    @generate_animations: ->
        anim =
            #blank
            waiting: [{x: 0,y: 0,width: 200,height: 200}]
            #3,2,1
            atk: [
                {x: 0,  y: 0,   width: 200,  height: 200}
                {x: 400, y: 0,   width: 200,  height: 200}
                {x: 200, y: 0,   width: 200,  height: 200}
                {x: 400, y: 0,   width: 200,  height: 200}
                {x: 0, y: 0,   width: 200,  height: 200}
                {x: 600, y: 0,   width: 200,  height: 200}
            ]
            def_plus: [
                {x: 0,  y: 0,   width: 200,  height: 200}
                {x: 0,  y: 200,   width: 200,  height: 200}
                {x: 200,  y: 200,   width: 200,  height: 200}
                {x: 0,  y: 200,   width: 200,  height: 200}
                {x: 0,  y: 0,   width: 200,  height: 200}
                {x: 0,  y: 200,   width: 200,  height: 200}
                {x: 200,  y: 200,   width: 200,  height: 200}
                {x: 0,  y: 200,   width: 200,  height: 200}
                {x: 0,  y: 0,   width: 200,  height: 200}
                {x: 0,  y: 200,   width: 200,  height: 200}
                {x: 200,  y: 200,   width: 200,  height: 200}
                {x: 0,  y: 200,   width: 200,  height: 200}
                {x: 0,  y: 0,   width: 200,  height: 200}
            ]
            atk_plus: [
                {x: 0,  y: 0,   width: 200,  height: 200}
                {x: 0,  y: 400,   width: 200,  height: 200}
                {x: 200,  y: 400,   width: 200,  height: 200}
                {x: 0,  y: 400,   width: 200,  height: 200}
                {x: 0,  y: 0,   width: 200,  height: 200}
                {x: 0,  y: 400,   width: 200,  height: 200}
                {x: 200,  y: 400,   width: 200,  height: 200}
                {x: 0,  y: 400,   width: 200,  height: 200}
                {x: 0,  y: 0,   width: 200,  height: 200}
                {x: 0,  y: 400,   width: 200,  height: 200}
                {x: 200,  y: 400,   width: 200,  height: 200}
                {x: 0,  y: 400,   width: 200,  height: 200}
                {x: 0,  y: 0,   width: 200,  height: 200}
            ]

        return anim


    ###
    ACTIONS
    ###
    @turn: (options) ->
        #flash message across screen? nah

    @turn_popover: (player_turn) ->
        op = 
            content: 'Your Turn!'
            trigger: 'manual'

        $('#you').popover('destroy')
        $('#enemy').popover('destroy')


        #display the tooltip
        if player_turn == Session.get('player_number')
            console.log('yours')
            $('#you').popover(op)
            $('#you').popover('show')
        else
            console.log("not yours")
            op['placement'] = 'left'
            $('#enemy').popover(op)
            $('#enemy').popover('show')

    @clear_grey: ->
        $('.board_item_graphic').removeClass('selected_tile')

    @make_grey: (target) ->
        $(target).addClass('selected_tile')
    
    ###
    SPRITE CONTROL
    ###
    @get_target: (player_num) ->
        if player_num == Session.get('player_number')
            return animation_controller.u_sprite
        else
            return animation_controller.e_sprite

    @stop_frame: (target,animation) ->
        max_frames = animation_controller.generate_animations()[animation].length-1
        target.afterFrame(max_frames, ->
              target.setAnimation('waiting')
        )

    @atk: (options) ->
        target = animation_controller.get_target(options['player_num'])
        target.setAnimation('atk')
        animation_controller.stop_frame(target,'atk')
        console.log('atk')

    @atk2: (options) ->
        target = animation_controller.get_target(options['player_num'])
        target.setAnimation('atk')
        animation_controller.stop_frame(target,'atk')
        console.log('atk2')

    @atk3: (options) ->
        target = animation_controller.get_target(options['player_num'])
        target.setAnimation('atk')
        animation_controller.stop_frame(target,'atk')
        console.log('atk3')

    @atk_plus: (options) ->
        target = animation_controller.get_target(options['player_num'])
        target.setAnimation('atk')
        animation_controller.stop_frame(target,'atk')
        console.log('atk_plus')

    @def_plus: (options) ->
        target = animation_controller.get_target(options['player_num'])
        target.setAnimation('def_plus')
        animation_controller.stop_frame(target,'def_plus')
        console.log('def_plus')


