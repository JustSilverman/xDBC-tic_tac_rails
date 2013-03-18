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
    this.images       = { 'X': settings.x_image, 'O': settings.o_image, " ": "" };
    this.startGame();
    gameMessages.init();
  },

  startGame: function(){
    if (this.playerToken == "X" ) {
      this.enableClicks();
    } else this.pollResults();
  },

  executeTurn: function(cell){
    this.checkCellContents(cell);
  },

  checkCellContents: function(cell){
    var cellText = $(cell).children('span');
    if (cellText.text() == " ") {
      this.updateCell(cell, cellText);
    }
  },

  updateCell: function(cell, cellText){
    cellText.text(game.playerToken);
    this.appendPhotoToCell(cell);
  },

  appendPhotoToCell: function(cell){
    $(cell).append(game.images[game.playerToken])
    this.updateCurrentBoard();
  },

  updateCurrentBoard: function(){
    this.currentBoard = $('.board td span').text();
    this.sendToServer();
  },

  sendToServer: function(){
    console.log(game.currentBoard);
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
    $('.board td img').remove();
    for (i in string) {
      $("#cell_"+i).append(this.images[string.charAt(i)]);
      $("#cell_"+i+" span").text(string.charAt(i));
    }
  },

  disableClicks: function(){
    game.cells.off('click');
  },

  enableClicks: function(){
    this.cells.on('click', function(){
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
