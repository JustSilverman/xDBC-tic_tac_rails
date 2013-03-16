var game = {
  init: function(settings){
    this.playerToken  = settings.player_token;
    this.playerID     = settings.player_id;
    this.moveUrl      = settings.move_url;
    this.winningUrl   = settings.winning_url;
    this.board        = $('.board');
    this.cells        = $('.board td');
    this.currentBoard = settings.current_board;
    gameMessages.init();
  },

  executeTurn: function(cell){
    this.checkCellContents(cell);
  },

  checkCellContents: function(cell){
    if ($(cell).text() == "") {
      this.updateCell(cell);
    }
  },

  updateCell: function(cell){
    $(cell).append(game.playerToken);
    this.updateCurrentBoard(cell);
  },

  updateCurrentBoard: function(cell){
    var indexToUpdate = $(cell).attr('id').charAt(id.length-1);
    this.substituteString(indexToUpdate);
  },

  substituteString: function(index){
    this.currentBoard = this.firstPart(index) + this.playerToken + this.lastPart(index);
    this.sendToServer(this.currentBoard);
  },

  firstPart: function(index){
    this.currentBoard.substring(0,index-1);
  },

  lastPart: function(index){
    this.currentBoard.substring(index-1, this.currentBoard.length-1);
  }

  sendToServer: function(cellText, cellID){
    $.ajax({
      url: this.moveUrl,
      type: "POST",
      data: this.currentBoard
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
      data: this.playerID
    }).done(function(){
      game.displayWinner("You've won!");
    })
  },


  pollResults: function(){
    $.ajax({
      url: "/game/board",
      type: "POST"
    }).done(function(data){
      game.checkStatus(data);
    });
  },

  checkStatus: function(data){
    if (this.currentBoard == data) {
      setTimeout(function(){this.pullResults()}, 2000);
    } else this.updateBoard(data);
  }

  updateBoard: function(string) {
    for (var i = 0; i < string.length; i++) {
      $("#cell_"+i).text(string.charAt(i));
    }
    if (checkForWinner(string)) {
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
// $('table').children.text()
