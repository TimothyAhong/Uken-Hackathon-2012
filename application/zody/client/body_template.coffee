Template.main.helpers
    game_index_page: -> Session.get('page') == 'game_index'
    game_page: -> Session.get('page') == 'game'
