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

        #determine which player slot is available and update model
        if game.players[0]? and !game.players[1]?
            num = 1
        if game.players[1]? and !game.players[0]?
            num = 0
        if !game.players[0]? and !game.players[1]?
            num = 0

        game_model.new_player(game_id, num)

        #update page and set player number
        Session.set('player_number',num)
        Session.set('page','game')

    ###
    PLAYER ACTIONS
    ###

    ###
    HELPERS
    ###
    @game_full: (game) ->
        return game['players'][0]? and game['players'][1]?