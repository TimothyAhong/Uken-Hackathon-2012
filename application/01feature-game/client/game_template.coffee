
###
HELPERS
###
Template.board.helpers
    board_rows: -> 
        if(Session.get('page') == 'game')
            game = game_model.get(Session.get('game_id'))
            console.log(game)
            return game['board']

Template.board_item.helpers
    class_list: ->
        str = ""
        #background color
        str+=" bkg_"+this.color
        #edge colors
        str+=" top_"+this.color_top
        str+=" right_"+this.color_right
        str+=" left_"+this.color_left
        str+=" bottom_"+this.color_bottom

Template.game_bottom.helpers
    my_hand: ->
        if(Session.get('game_id'))
            game = game_model.get(Session.get('game_id'))
            return game['players'][Session.get('player_number')]['hand']

Template.game_top.helpers
    their_hand: ->
        if(Session.get('game_id'))
            game = game_model.get(Session.get('game_id'))
            num = if Session.get('player_number') == 1 then 0 else 1
            if game['players'][num]?
                return game['players'][num]['hand']
###
EVENTS
###
Template.board_item.events
    'click .board_item': (evt) ->
        console.log(this)
        if this.location == "board"
            game_controller.place_tile(this,evt)
        if this.location == "my hand"
            game_controller.select_tile(this,evt)
