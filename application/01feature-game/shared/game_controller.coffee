class game_controller
    ###
    SETUP
    ###

    ###
    PLAYER JOIN
    ###
    @play: (game_id) ->
        game = game_model.get(game_id)
        console.log game
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
        console.log(options)
        len = options.length
        return options[Math.floor( Math.random()*(len-1) )]

    @generate_random_action: (rank) ->
        options = [
            ['atk'],
            ['atk2','atk_plus','def_plus'],
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
        update.$set.players[player_num]['hand'][0] = game_controller.generate_random_tile(0, location, 0, 0)
        update.$set.players[player_num]['hand'][1] = game_controller.generate_random_tile(1, location, 1, 0)
        update.$set.players[player_num]['hand'][2] = game_controller.generate_random_tile(1, location, 2, 0)
        update.$set.players[player_num]['hand'][3] = game_controller.generate_random_tile(1, location, 3, 0)
        update.$set.players[player_num]['hand'][4] = game_controller.generate_random_tile(2, location, 4, 0)
        game_model.update(game_id,update)

    @switch_turn: (game_id) ->
        #if we can place the tile then do the swap
        update = new mongo_update
        update.$set.player_turn = if Session.get('player_number')==1 then 0 else 1
        game_model.update(game_id,update)

    @dmg: (def,atk) ->
        n = atk - def
        if n < 1
            n = 1
        return n

    @action: (tile,players,player_num) ->
        other_num = if player_num == 1 then 0 else 1

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
        game_controller.dealto(game_id,player_num)
        game_controller.switch_turn(game_id,player_num)

    @select_tile: (target,evt) ->
        #set the active tile
        game_controller.active_tile = target

    @place_tile: (target,evt) ->
        game_id = Session.get('game_id')
        player_num = Session.get('player_number')
        #person just clicking around
        if !game_controller.active_tile? or !game_controller.active_tile
            return

        placeable = game_controller.active_tile
        game = game_model.get(game_id)

        #make sure its this players turn
        if game.player_turn != player_num
            return

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

        game_model.update(game_id,update)

        game_controller.active_tile = false
        game_controller.switch_turn(game_id)


    ###
    HELPERS
    ###
    @check_tile_color: (board) ->
    @game_full: (game) ->
        return game['players'][0]? and game['players'][1]?

    