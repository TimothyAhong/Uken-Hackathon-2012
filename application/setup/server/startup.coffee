Meteor.startup ->
    ###
    CONTROLLER SETUP
    ###

    ###
    SAMPLE DATA
    ###
    anims.remove({})
    games.remove({})
    game_model.new_game('This is a game')
    game_model.new_game('This is another game')
    game_model.new_game('This is yet another game')