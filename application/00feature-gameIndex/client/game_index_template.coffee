###
HELPERS
###
Template.game_index.helpers
    game_index_items : -> game_index_model.get_all()

Template.game_index_item.helpers
    game_full_status : -> return if this.players.length == 2 then "disabled" else ""
    game_full_message : -> return if this.players.length == 2 then "Game Full" else "Play"

###
EVENTS
###
Template.game_index_item.events  
    'click #play_game': (evt) ->
        #play in this game
        game_id = this._id
        game_controller.play(game_id)

    'click #watch_game': (evt) ->
        #play in this game
        game_id = this._id
        game_controller.watch_game(game_id)

Template.game_index.events
    'click #create_game': (evt) ->
        val = $('#create_game_input').val()
        game_model.new_game(val)