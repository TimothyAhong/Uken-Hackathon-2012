class game_controller
    ###
    SETUP
    ###

    ###
    PLAYER JOIN
    ###
    @play: (game_id) ->
        game = game_model.get(game_id)
        #check if this game is full
        if game_controller.game_full(game)
            #TODO flash game full message
            return

        #determine which player slot is available, if both are available then select player 0

        #this breaks if player 1 leaves
        if game.players[0]?
            num = 1
        else
            num = 0

        game_model.new_player(game_id, num)

        #update page and set player number
        Session.set('player_number',num)
        Session.set('game_id',game_id)
        Session.set('page','game')

        #setup our animations
        animation_model.setup()

    ###
    GENERATE
    ###
    @generate_random_color: ->
        options = ['red','blue','green']
        return options[Math.floor((Math.random()*3))]

    @generate_random_edge: (edge_not)->
        options = ['top','bottom','left','right']
        if edge_not?
            options = _.reject(options, (option) -> option == edge_not)
        len = options.length
        return options[Math.floor( Math.random()*(len) )]

    @generate_random_action: (rank) ->
        options = [
            ['atk','def_plus'],
            ['atk2','atk_plus'],
            ['atk3']
        ]
        len = options[rank].length
        return options[rank][Math.floor((Math.random()*len))]

    @generate_random_tile: (rank, location, y, x) ->
        
        if rank == false
            rank = Math.floor(Math.random()*3)

        tile = game_model.default_tile(location, y, x)

        tile.action = game_controller.generate_random_action(rank)
        tile.type = game_controller.generate_random_action(rank)
        tile.color = game_controller.generate_random_color()

        if rank == 0
            return tile

        edge1 = game_controller.generate_random_edge()
        tile['color_'+edge1] = game_controller.generate_random_color()
        if rank == 1
            return tile

        edge2 = game_controller.generate_random_edge(edge1)
        tile['color_'+edge2] = game_controller.generate_random_color()
        if rank == 2
            return tile
        
    ###
    INNER ACTIONS
    ###
    @dealto: (game_id,player_num) ->
        game = game_model.get(game_id)
        location = player_num

        update = new mongo_update
        update.$set.players = game.players
        update.$set.players[player_num]['hand'] = []

        #the ranks of the starting hand
        ranks = [0,0,0,1,1,1,2,2]
        for i in [0..ranks.length-1]
            update.$set.players[player_num]['hand'][i] = game_controller.generate_random_tile(ranks[i], location, i, 0)

        game_model.update(game_id,update)

    @switch_turn: (game_id) ->
        #if we can place the tile then do the swap
        update = new mongo_update
        turn = if Session.get('player_number')==1 then 0 else 1
        update.$set.player_turn = turn
        game_model.update(game_id,update)

        #update animation to display the correct turn
        options = 
            'current_turn' : turn
        animation_model.add('turn',options)

    @dmg: (def,atk) ->
        n = atk - def
        if n < 1
            n = 1
        return n

    @action: (tile,players,player_num) ->
        other_num = if player_num == 1 then 0 else 1
        #TODO update animation db based on the action
        switch(tile.action)
            when "atk"
                players[other_num]['hearts'] -= game_controller.dmg(players[other_num]['def'],players[player_num]['atk'])
            when "atk2"
                players[other_num]['hearts'] -= game_controller.dmg(players[other_num]['def'],players[player_num]['atk'])
                players[other_num]['hearts'] -= game_controller.dmg(players[other_num]['def'],players[player_num]['atk'])
            when "atk3"
                players[other_num]['hearts'] -= game_controller.dmg(players[other_num]['def'],players[player_num]['atk'])
                players[other_num]['hearts'] -= game_controller.dmg(players[other_num]['def'],players[player_num]['atk'])
                players[other_num]['hearts'] -= game_controller.dmg(players[other_num]['def'],players[player_num]['atk'])
            when "atk_plus"
                players[player_num]['atk'] += 1
            when "def_plus"
                players[player_num]['def'] += 1

        return players

    ###
    PLAYER ACTIONS
    ###
    @draw_cards: (game_id,player_num) ->
        game = game_model.get(game_id)
        return if not game_controller.my_turn(game,player_num)

        game_controller.dealto(game_id,player_num)
        game_controller.switch_turn(game_id,player_num)
        #TODO call animation for card drawing (they get covered then show up again?)

    @select_tile: (target,evt) ->
        #set the active tile
        game_controller.active_tile = target
        #TODO call local animation for selecing the tile

    @place_tile: (target,evt) ->
        game_id = Session.get('game_id')
        player_num = Session.get('player_number')
        #person just clicking around
        if !game_controller.active_tile? or !game_controller.active_tile
            return

        placeable = game_controller.active_tile
        game = game_model.get(game_id)

        #make sure its this players turn
        return if not game_controller.my_turn(game,player_num)

        #check if this tile is occupied
        if target.color != 'w'
            return

        #check if adjacent tiles are not right
        if placeable.color_bottom != 'w'
            if target.y == game_constants.board_height
                return
            if placeable.color_bottom != game.board[target.y+1][target.x]['color']
                return

        if placeable.color_top != 'w'
            if target.y == 0
                return
            if placeable.color_top != game.board[target.y-1][target.x]['color']
                return

        if placeable.color_left != 'w'
            if target.x == 0
                return
            if placeable.color_left != game.board[target.y][target.x-1]['color']
                return

        if placeable.color_right != 'w'
            if target.x == game_constants.board_width
                return
            if placeable.color_right != game.board[target.y][target.x+1]['color']
                return

        #if we can place the tile then do the swap and remove the tile from your hand
        update = new mongo_update
        update.$set.board = game.board
        update.$set.board[target.y][target.x] = placeable

        update.$set.players = game.players
        update.$set.players[player_num]['hand'][placeable.y] = game_controller.generate_random_tile(false, player_num, placeable.y, 0)
        
        #do the action on the tile
        update.$set.players = game_controller.action(placeable,game.players,player_num)

        #update model
        game_model.update(game_id,update)
        #TODO update animation db for placing a tile


        #update self
        game_controller.active_tile = false
        game_controller.switch_turn(game_id)


    ###
    HELPERS
    ###
    @check_tile_color: (board) ->
    @game_full: (game) ->
        return game['players'][0]? and game['players'][1]?

    @my_turn: (game,player_num) ->
        return game.player_turn == player_num

    