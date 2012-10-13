###
LIFECYLE
###
Template.board.created = ->
    animation_controller.board_first = true
Template.board.rendered = ->
    if animation_controller.board_first
        animation_controller.setup()
        animation_controller.board_first = false

Template.victory_modal.rendered = ->
    options = 
        show: false
    $('#victory_modal').modal(options)

Template.defeat_modal.rendered = ->
    options = 
        show: false
    $('#defeat_modal').modal(options)

Template.board_item.rendered = ->
    $('.action_atk_plus').tooltip({title:'Increase your attack!'})
    $('.action_atk').tooltip({title:'Attack once!'})
    $('.action_atk2').tooltip({title:'Attack twice!!'})
    $('.action_atk3').tooltip({title:'Attack thrice!!!'})
    $('.action_def_plus').tooltip({title:'Increase your Defence!'})

Template.game_bottom.rendered = ->
    $("#new_hand").tooltip({title:'Get a new set of tiles!'})

###
HELPERS
###
Template.board.helpers
    board_rows: -> 
        if(Session.get('page') == 'game')
            game = game_model.get(Session.get('game_id'))
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
        
        if this.action
            str+=" action_"+this.action
        else
            str+=" action_empty"

        return str

Template.game_bottom.helpers
    my_hand: ->
        if(Session.get('game_id'))
            game = game_model.get(Session.get('game_id'))
            return game['players'][Session.get('player_number')]['hand']
    my_hearts: ->
        game = game_model.get(Session.get('game_id'))
        return game['players'][Session.get('player_number')]['hearts']
    my_def: ->
        game = game_model.get(Session.get('game_id'))
        return game['players'][Session.get('player_number')]['def']
    my_atk: ->
        game = game_model.get(Session.get('game_id'))
        return game['players'][Session.get('player_number')]['atk']


Template.game_top.helpers
    their_hand: ->
        if(Session.get('game_id'))
            game = game_model.get(Session.get('game_id'))
            num = if Session.get('player_number') == 1 then 0 else 1
            if game['players'][num]?
                return game['players'][num]['hand']
    their_hearts: ->
        game = game_model.get(Session.get('game_id'))
        num = if Session.get('player_number') == 1 then 0 else 1
        if game['players'][num]?
            return game['players'][num]['hearts']
        else return 0

    their_def: ->
        game = game_model.get(Session.get('game_id'))
        num = if Session.get('player_number') == 1 then 0 else 1
        if game['players'][num]?
            return game['players'][num]['def']
        else return 0

    their_atk: ->
        game = game_model.get(Session.get('game_id'))
        num = if Session.get('player_number') == 1 then 0 else 1
        if game['players'][num]?
            return game['players'][num]['atk']
        else return 0
###
EVENTS
###
Template.board_item.events
    'click .board_item': (evt) ->
        if this.location == "board"
            game_controller.place_tile(this,evt)
        if this.location == Session.get('player_number')
            console.log(evt.target)
            animation_controller.clear_grey()
            animation_controller.make_grey(evt.target)

            game_controller.select_tile(this,evt)

Template.game_bottom.events
    'click #new_hand': (evt) ->
        game_controller.draw_cards(Session.get('game_id'),Session.get('player_number'))

Template.defeat_modal.events
    'click #exit': (evt) -> document.location.reload(true)

Template.victory_modal.events
    'click #exit': (evt) -> document.location.reload(true)
