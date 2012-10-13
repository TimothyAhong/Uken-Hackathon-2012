class animation_controller
    @setup: ->
        console.log("BBB")

    @turn: (options) ->
        #flash message? nah

    @turn_popover: (player_turn) ->
        op = 
            content: 'Your Turn!'
            trigger: 'manual'

        $('#you').popover('destroy')
        $('#enemy').popover('destroy')


        #display the tooltip
        if player_turn == Session.get('player_number')
            console.log('yours')
            $('#you').popover(op)
            $('#you').popover('show')
        else
            console.log("not yours")
            op['placement'] = 'left'
            $('#enemy').popover(op)
            $('#enemy').popover('show')
