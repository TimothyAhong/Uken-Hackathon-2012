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
                item[i][j] = game_model.default_tile()
        return item

    @default_tile: ->
        item =
            type        : 'empty'
            class_outer : 'empty_outer'
            class_inner : 'empty_inner'
            color       : 'w'
            color_bot   : 'w'
            color_top   : 'w'
            color_left  : 'w'
            color_right : 'w'
            action      : false
        return item

    ###
    GETTER
    ###
    @get: (game_id) ->
        games.findOne({_id:game_id})

    ###
    INSERT/DELETE
    ###
    @new_game: (name) ->
        games.insert(game_model.default_game(name))

    @new_player: (game_id, player_num) ->
        #update
        update = new mongo_update
        update.$set.players = {}
        update.$set.players[player_num] = game_model.default_player(player_num)
        console.log update
        game_model.update(game_id,update)


    ###
    UPDATE
    ###
    @update: (game_id, update_array_mongo) ->
        games.update({_id:game_id}, update_array_mongo)
        return true


