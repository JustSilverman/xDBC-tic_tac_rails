module GamesHelper
  def icon(board_cell)
    if board_cell ==  "X"
      image_tag "/assets/X.png", class: "board-icon"
    elsif board_cell ==  "O"
      image_tag "/assets/O.png", class: "board-icon"
    end
  end
end
