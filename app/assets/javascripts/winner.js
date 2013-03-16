var checkForWinner = {
  init: function(gameBoard){
    this.winningTriplets = ['012', '048', '036', '147', '258', '246', '345', '678'];
    return this.testBoard(gameBoard);
  },

  testBoard: function(gameBoard){
    for (var i = 0; i < this.winningTriplets.length; i++) {
      var ele = this.winningTriplets[i]
      if (gameBoard.charAt(ele[0]) + gameBoard.charAt(ele[1]) + gameBoard.charAt(ele[2]) == "OOO" || gameBoard.charAt(ele[0]) + gameBoard.charAt(ele[1]) + gameBoard.charAt(ele[2]) == "XXX"){
        return true;
      }
    }
  }
}
