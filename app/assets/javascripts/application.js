//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {

  game.init();

  game.cells.on('click', function(){
    game.executeTurn(this);
  });
});
