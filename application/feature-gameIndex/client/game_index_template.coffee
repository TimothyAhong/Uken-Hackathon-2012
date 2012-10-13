
###
HELPERS
###
Template.game_index.helpers
    game_index_items : -> game_index_model.get_all()


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