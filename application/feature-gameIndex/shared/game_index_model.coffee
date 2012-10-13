class game_index_model
    ###
    INSERT/DELETE
    ###
    @create_game: (name) ->

    @get_all: ->
        games.find({}).fetch()