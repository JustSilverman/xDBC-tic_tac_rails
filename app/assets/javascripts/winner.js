mvar checkForWinner = {
  init: function(gameBoard){
    this.winningTriplets = ['012', '048', '036', '147', '258', '246', '345', '678'];
    testBoard(gameBoard);
  },

  testBoard: function(){
    for (var i = 0; i < this.winningTriplets.length; i++) {
      var ele = this.winningTriplets[i]
      if (gameBoard.charAt([ele[0]]) == gameBoard.charAt([ele[1]]) == gameBoard.charAt([ele[2]]){
        return true
      }
    }
  }
}
