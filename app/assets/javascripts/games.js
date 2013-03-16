var game = {
  init: function(settings){
    this.playerToken  = settings.player_token;
    this.playerID     = settings.player_id;
    this.moveUrl      = settings.move_url;
    this.winningUrl   = settings.winning_url;
    this.pollingUrl   = settings.polling_url;
    this.board        = $('.board');
    this.cells        = $('.board td');
    // this.cellText     = $('.board td span')
    // this.boardFromDOM = $('.board td span').text();
    this.currentBoard = settings.current_board;
    this.startGame();
    gameMessages.init();
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

  updateCurrentBoard: function(){
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
    this.checkGameStatusBeforePolling(data);
  },

  checkGameStatusBeforePolling: function(data){
    if (checkForWinner.init(data)) {
      this.postWinner();
    } else if (this.checkForTie()) {
      this.displayMessage(gameMessages.tie); 
    } else this.pollResults();
  },

  postWinner: function(){
    $.ajax({
      url: this.winningUrl,
      type: "POST",
      data: {winner_id: this.playerID }
    }).done(function(){
      game.displayMessage(gameMessages.winner);
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
    this.currentBoard = string;
    this.populateTable(string);
    this.checkGameStatusAfterPolling();
  },

  checkGameStatusAfterPolling: function(){
    if (checkForWinner.init(this.currentBoard)) {
      this.displayMessage(gameMessages.loser);
    } else if (this.checkForTie()) {
      this.displayMessage(gameMessages.tie);
    } else game.enableClicks();
  },

  populateTable: function(string){
    for (var i = 0; i < string.length; i++) {
      $("#cell_"+i).text(this.renderCell(string.charAt(i) ));
    }
  },

  renderCell: function(char){
    if (char == "X") {
      return xImage;
    } else if (char == "O") {
      return oImage;
    }
  },

  disableClicks: function(){
    game.cells.off('click');
  },

  enableClicks: function(){
    game.cells.on('click', function(){
      game.executeTurn(this);
    });
  },

  displayMessage: function(message){
    this.board.prepend(message);
  },

  checkForTie: function(){
    if (game.currentBoard.indexOf(" ") === -1) return true;
  }
}
