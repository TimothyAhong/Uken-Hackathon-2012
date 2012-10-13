###
STORE
###
anims = new Meteor.Collection("anims")

###
MODEL
###
class animation_model

    @setup: ->
        animation_model.observe()

    @add: (fun,options) ->
        anims.insert({game_id:Session.get('game_id'),fun:fun,options:options})

    @observe: ->
        #squabblers
        anims.find({ game_id:Session.get('game_id') }).observe
            added: (doc, beforeIndex) ->
                console.log(doc)
                animation_controller[doc['fun']](doc['options'])

        games.find({ _id:Session.get('game_id') }).observe
            changed: (doc) ->
                animation_controller.turn_popover(doc.player_turn)

