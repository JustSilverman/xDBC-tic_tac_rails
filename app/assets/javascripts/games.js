var game = {
  init: function(settings){
    this.playerToken  = settings.player_token;
    this.playerID     = settings.player_id;
    this.moveUrl      = settings.move_url;
    this.winningUrl   = settings.winning_url;
    this.pollingUrl   = settings.polling_url;
    this.board        = $('.board');
    this.cells        = $('.board td');
    this.currentBoard = settings.current_board;
    this.startGame();
  },

  startGame: function(){
    if (this.playerToken == "X" ) {
      game.cells.on('click', function(){
        game.executeTurn(this);
      });
    } else this.pollResults();
  },

  executeTurn: function(cell){
    this.checkCellContents(cell);
  },

  checkCellContents: function(cell){
    if ($(cell).text() == " ") {
      this.updateCell(cell);
    }
  },

  updateCell: function(cell){
    $(cell).text(game.playerToken);
    this.updateCurrentBoard(cell);
  },

  updateCurrentBoard: function(cell){
    var indexToUpdate = $(cell).attr('id').substring(5);
    this.substituteString(indexToUpdate);
  },

  substituteString: function(index){
    this.currentBoard = this.cells.text();
    this.sendToServer();
  },

  sendToServer: function(){
    $.ajax({
      url: this.moveUrl,
      type: "POST",
      data: { board: game.currentBoard },
      dataType: "json"
    }).done(function(data){
      game.waitForUpdate(data);
    });
  },

  waitForUpdate: function(data){
    this.currentBoard = data;
    this.disableClicks();
    if (checkForWinner.init(data)) {
      this.postWinner();
    }
    this.pollResults();
  },

  postWinner: function(){
    $.ajax({
      url: this.winningUrl,
      type: "POST",
      data: {winner_id: this.playerID }
    }).done(function(){
      game.displayWinner("You've won!");
    })
  },

  pollResults: function(){
    $.ajax({
      url: this.pollingUrl,
      type: "get",
      dataType: "json"
    }).done(function(data){
      game.checkStatus(data);
    });
  },

  checkStatus: function(data){
    if (this.currentBoard == data) {
      setTimeout(function(){game.pollResults()}, 500);
    } else this.updateBoard(data);
  },

  updateBoard: function(string) {
    for (var i = 0; i < string.length; i++) {
      $("#cell_"+i).text(string.charAt(i));
    }
    if (checkForWinner.init(string)) {
      game.displayWinner("You've lost!");
    } else game.enableClicks();
  },

  disableClicks: function(){
    game.cells.off('click');
  },

  enableClicks: function(){
    game.cells.on('click', function(){
      game.executeTurn(this);
    });
  },

  displayWinner: function(message){
    this.board.prepend(message);
  }
}
