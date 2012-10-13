###
STORE
###
games = new Meteor.Collection("games")

###
MODEL
###
class game_model
    ###
    DEFAULTS
    ###
    @default_game: (name) ->
        item = 
            name:name
            players: []
            board: game_model.default_board()
            state: "not started"
            player_turn: 1
        return item

    @default_player: (player_num) ->
        item =
            num: player_num
            hand: []
            hearts: 10
        return item

    @default_board: ->
        item = []
        #2D array of tiles
        for i in [0..game_constants.board_height-1]
            item[i] = []
            for j in [0..game_constants.board_width-1]
                item[i][j] = game_model.default_tile('board',i,j)
        return item

    @default_tile: (location,y,x)->
        item = []
        item =
            'type'        : 'empty'
            'color'       : 'w'
            'color_bottom': 'w'
            'color_top'   : 'w'
            'color_left'  : 'w'
            'color_right' : 'w'
            'action'      : false
            'location'     : location
            'y'           : y
            'x'           : x
        return item

    ###
    GETTER
    ###
    @get: (game_id) -> games.findOne({_id:game_id})

    ###
    INSERT/DELETE
    ###
    @new_game: (name) ->
        games.insert(game_model.default_game(name))

    @new_player: (game_id, player_num) ->
        #update
        game = game_model.get(game_id)
        update = new mongo_update
        update.$set.players = game.players
        update.$set.players[player_num] = game_model.default_player(player_num)
        game_model.update(game_id,update)

    @remove_tile: (game_id, player_num, location, y, x) ->
        game = game_model.get(game_id)
        update = new mongo_update

        if location == 'board'
            console.log("you should never see this")
            return

        #determine the player number
        if location == 'my hand'
            num = player_num
        else
            num = if player_num == 0 then 1 else 0

        #remove that item from that persons hand
        update.$set.players = game.players
        update.$set.players[num]['hand'] = game.players[num]['hand'].splice(y,1)
        game_model.update(game_id,update)

    ###
    UPDATE
    ###
    @update: (game_id, update_array_mongo) ->
        games.update({_id:game_id}, update_array_mongo)
        return true


