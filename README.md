Dominotion
================================

###### What?

Dominotion is multi-player tile based game. Go head to head with a friend (or a random person online) placing tiles to control your warrior. Take down the opponent's warrior before they take down yours!

You can play Dominotion for free at the following URLs
* [uken_hackathon.meteor.com](http://uken_hackathon.meteor.com)
* [dominotion.meteor.com](http://dominotion.meteor.com)
* [dominotion2.meteor.com](http://dominotion2.meteor.com)

If you want to build and run your own Dominotion server see below  

###### Why?
Uken hackathon

###### Who?
* Timothy Ahong: ahong.timothy@gmail.com
* Andrea Pagotto: ajpagotto@gmail.com


How do I play this awesome game?
--------------------------------

###### Rules

1. Click new hand
2. Place one of your tiles on the board, each tile with a coloured edge must be placed touching a tile of that colour
3. Each tile will cause your character to either attack, increase strength, or increase  defense
4. If your opponents's health reaches 0, you win
5. If you can not play any tiles, or want different ones, you can click 'new hand', which will use up your turn
 
###### Legend

Fist: Increase attack points by 1   
Swords: attack times the number of swords, to do damage to your opponent   
Shield: increase your defense points by one, reducing the damage done by your opponent   

###### Ok enough rules I want to play! NOW!

Dude, calm down. Follow these steps and everything will be alright...

1. Goto [uken_hackathon.meteor.com](http://uken_hackathon.meteor.com)
2. Create a game by typing your desired game name and selecting 'Create Game'
3. Find a friend and have them join your game (you need 2 people to play)
    * If you have no friends we'll be your friends. Add us on GChat and we'll play with you
4. Execute your turn (or chill if its your friends turn)
    * If you have a tile that you would like to place click the tile in your hand and then click the spot where you would like to put it
    * If you are out of tiles, have no tiles you would like to place or have no tiles that can be placed then select draw new tiles (this will skip your current turn)
5. Repeat step 4 until the board is full or one play runs out of hearts
    * The player that ran out of hearts loses
    * If the board is full then the player has the most remaining hearts wins!

Whats up with these codes?
--------------------------------

A full suite of hip new fangled technologies were used when developing Dominotion. Lets break it down:
* [Meteor](https://meteor.com)
* [Coffeescript](http://coffeescript.org)
* [Handlebars](http://handlebarsjs.com)
* [KineticJS](http://kineticjs.com)
* [Bootstrap](http://twitter.github.com/bootstrap)
* [JQuery](http://jquery.com/)
* [LESS](http://lesscss.org/)
* [Underscore](http://documentcloud.github.com/underscore/)

###### Server and framework
Dominotion rests within the MeteorJS framework. Through Meteor we have used coffeescript for the server and client side code. Styling has been with basic CSS and templating with HTML with handlebars

###### Graphics and visuals
For the motion graphics we used KineticJS, a lightweight graphics framework that utilizes HTML5 canvas. KineticJS has a simple sprite management system that was very usefull. For the board we used straight up HTML tables (with help from bootstrap) and CSS. The base image for the sprites has been taken from BattleHeart.

###### But will it scale?
Unlikely...
You could probably bring the free server to its knees with a dozen or so concurrent games

How do I run my own Dominotion Server?
--------------------------------
1. First you'll need meteor you can get it by checking out [Meteor](https://meteor.com). Or by running the following command
<pre>
$ curl https://install.meteor.com | sh
</pre>
2. Download the source
3. Navigate to the folder and run
<pre>
$ meteor
</pre>


