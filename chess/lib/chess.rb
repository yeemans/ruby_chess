# board.cells[1][0].square is equal to piece.square[0, 1]
class Piece 
  attr_accessor :char, :square, :moves, :color
  def initialize(char, square, moves, color)
    @char = char # character representing the piece 
    @square = square
    @moves = moves # 2d array of moves possible from position
    @color = color # white or black
  end
end

class Board 
  attr_accessor :cells
  def initialize(cells)
    @cells = cells
  end
end
# creating blank board 
board = []
board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
board = Board.new(board)

def filter_moves(piece, board)
  to_delete = []
  piece.moves.each do |square| # filter out unavailable moves 
    if board.cells[square[1]][square[0]] != "#" 
      # can't move to square that is occupied 
      if piece.color == board.cells[square[1]][square[0]].color
        to_delete.push(square)
      end
      # if the blocking piece is to the left, remove options with < column 
      if board.cells[square[1]][square[0]].square[0] < piece.square[0] && 
        board.cells[square[1]][square[0]].square[1] == piece.square[1]
        i = square[0]
        while i > 0 
          i -= 1
          to_delete.push([i, square[1]])
        end
      end
      # if the blocking piece is the right, remove options with > column
      if board.cells[square[1]][square[0]].square[0] > piece.square[0] &&
        board.cells[square[1]][square[0]].square[1] == piece.square[1]
        i = square[0]
        while i < 7 
          i += 1
          to_delete.push([i, square[1]])
        end
      end
      # if the blocking piece is above, remove options with < row 
      if board.cells[square[1]][square[0]].square[1] < piece.square[1] && 
        board.cells[square[1]][square[0]].square[0] == piece.square[0]
        i = square[1]
        while i > 0 
          i -= 1
          to_delete.push([square[0], i])
        end
      end
      # if the blocking piece is below, remove options with > row 
      if board.cells[square[1]][square[0]].square[1] > piece.square[1] && 
        board.cells[square[1]][square[0]].square[0] == piece.square[0]
        i = square[1]
        while i < 7 
          i += 1 
          to_delete.push([square[0], i])
        end 
      end
      # blocking diagonal moves for bishop and queen, starting from left up
      q = "\u2655"
      b = "\u2657"
      q2 = "\u265B"
      b2 = "\u265D"
      if piece.char == b || piece.char == q || piece.char == b2 ||
      piece.char == q2
      # if there is a blocking piece in piece.moves, remove its diagonal path 
        piece.moves.each do |spot| 
          if board.cells[spot[1]][spot[0]] != "#" 
            # iterate over the diagonal paths from this spot
            # left and above 
            if piece.square[1] > spot[1]
              i = spot[0]
              j = spot[1]
              while i > 0 && j > 0 
                i -= 1 
                j -= 1 
                to_delete.push([i, j])
              end
              i = spot[0]
              j = spot[1]
              # right and above
              while i < 7 && j > 0 
                i += 1 
                j -= 1 
                to_delete.push([i, j])
              end
            else
              # left and below
              i = spot[0]
              j = spot[1]
              while i > 0 && j < 7
                i -= 1 
                j += 1 
                to_delete.push([i, j])
              end
              # right and below 
              i = spot[0]
              j = spot[1]
              while i < 7 && j < 7 
                i += 1 
                j += 1 
                to_delete.push([i, j])
              end
            end
          end
        end
      end
    end
  end
  to_delete.each do |gone| 
    piece.moves.delete(gone)
  end
  # correcting rook behavior where you can't capture to one square right/left 
  r = "\u2656"
  r2 = "\u265C"
  if piece.char == r || piece.char == r2 
    if piece.square[0] < 7
      if board.cells[piece.square[1]][piece.square[0] + 1] != "#"
        if board.cells[piece.square[1]][piece.square[0] + 1].color != piece.color 
          piece.moves.push([piece.square[1], piece.square[0] + 1])
        end
      end
    end
    if piece.square[1] > 0
      if board.cells[piece.square[1]][piece.square[0] - 1] != "#"
        if board.cells[piece.square[1]][piece.square[0] - 1].color != piece.color 
          piece.moves.push([piece.square[1], piece.square[0] - 1])
        end
      end
    end
    piece.moves = piece.moves.uniq
  end
  return piece.moves
end 

def rook_moves(piece, board) 
  moves = []
  i = piece.square[0]
  j = piece.square[0]
  while i < 7 # moves to right of rook
    i += 1 
    moves.push([i, piece.square[1]])
  end

  while j > 0 # moves to the left of rook 
    j -= 1 
    moves.push([j, piece.square[1]])
  end

  i = piece.square[1]
  j = piece.square[1]
  while i < 7 # moves below rook
    i += 1 
    moves.push([piece.square[0], i])
  end 
  while j > 0 # moves above rook
    j -= 1 
    moves.push([piece.square[0], j])
  end
  piece.moves = moves
  return filter_moves(piece, board)
end

def knight_moves(piece, board)
  moves = []
  # moves 2 spaces down from the knight  
  moves.push([piece.square[0] - 1, piece.square[1] - 2]) if 
  piece.square[1] > 1 && piece.square[0] > 0

  moves.push([piece.square[0] + 1, piece.square[1] - 2]) if 
  piece.square[1] > 1 && piece.square[0] < 7
  # moves 1 space down from the knight 
  moves.push([piece.square[0] - 2, piece.square[1] - 1]) if 
  piece.square[1] > 0 && piece.square[0] > 1

  moves.push([piece.square[0] + 2, piece.square[1] - 1]) if 
  piece.square[1] > 0 && piece.square[0] < 6
  #moves 1 space above the knight 

  moves.push([piece.square[0] - 2, piece.square[1] + 1]) if 
  piece.square[1] < 7 && piece.square[0] > 1

  moves.push([piece.square[0] + 2, piece.square[1] + 1]) if 
  piece.square[1] < 7 && piece.square[0] < 6
  # moves 2 spaces above the knight
  moves.push([piece.square[0] - 1, piece.square[1] + 2]) if 
  piece.square[1] < 6 && piece.square[0] > 0 

  moves.push([piece.square[0] + 1, piece.square[1] + 2]) if 
  piece.square[1] < 6 && piece.square[0] < 7

  piece.moves = moves
  return filter_moves(piece, board)
end

def bishop_moves(piece, board)
  moves = []
  original = piece.square.clone
  # top right bishop moves
  while original[0] < 7 && original[1] < 7
    original[0] += 1 
    original[1] += 1 
    moves.push([original[0], original[1]]) 
  end
  original = piece.square.clone 
  # top left bishop moves 
  while original[0] > 0 && original[1] < 7 
    original[0] -= 1 
    original[1] += 1 
    moves.push([original[0], original[1]])
  end
  original = piece.square.clone
  # bottom right bishop moves  
  while original[0] < 7 && original[1] > 0 
    original[0] += 1 
    original[1] -= 1 
    moves.push([original[0], original[1]])
  end 
  original = piece.square.clone
  # bottom left bishop moves
  while original[0] > 0 && original[1] > 0 
    original[0] -= 1 
    original[1] -= 1 
    moves.push([original[0], original[1]])
  end

  piece.moves = moves
  return filter_moves(piece, board)
end

def queen_moves(piece, board)
  # big brain moment, queen has the moves of a bishop and rook combined
  moves = []
  # only works when getting bishop moves through a copy, for some reason
  board.cells[piece.square[1]][piece.square[0]] = 
  Piece.new("\u2656", piece.square, [], piece.color)
  # define the moves for our dummy rook
  board.cells[piece.square[1]][piece.square[0]].moves = 
  rook_moves(board.cells[piece.square[1]][piece.square[0]], board)
  # add moves from dummy rook to the queen, iteratively
  board.cells[piece.square[1]][piece.square[0]].moves.each do |move| 
    moves.push(move)
  end
  # iterate over bishop moves, pushing it normally appends a 2d array
  bishop_moves(piece, board).each do |move| 
    moves.push(move)
  end
  piece.moves = moves 
  board.cells[piece.square[1]][piece.square[0]] = piece
  return moves
end

def king_moves(piece, board)
  moves = []

  if piece.square[0] > 0 
    moves.push([piece.square[0] - 1, piece.square[1]])
    if piece.square[1] > 0
      moves.push([piece.square[0] - 1, piece.square[1] - 1])
    end 
    if piece.square[1] < 7 
      moves.push([piece.square[0] - 1, piece.square[1] + 1])
    end
  end

  if piece.square[0] < 7
    moves.push([piece.square[0] + 1, piece.square[1]])
    if piece.square[1] > 0 
      moves.push([piece.square[0] + 1, piece.square[1] - 1])
    end 
    if piece.square[1] < 7 
      moves.push([piece.square[0] + 1, piece.square[1] + 1])
    end
  end

  moves.push([piece.square[0], piece.square[1] - 1]) if piece.square[1] > 0
  moves.push([piece.square[0], piece.square[1] + 1]) if piece.square[1] < 7
  # king cannot move to a square if he may be captured by said move 
  pn = "\u2659"
  pn2 = "\u265F"

  # stupid fucking pawns move change when diagonal, so filter out those moves  
  if piece.color == "black"
    if piece.square[0] >= 2 && piece.square[1] <= 5
      lower_left = [piece.square[0] - 2, piece.square[1] + 2]
      lower_left = board.cells[lower_left[1]][lower_left[0]]
      if lower_left != "#" 
        if lower_left.color != piece.color && lower_left.char == pn2 
          moves.delete([piece.square[0] - 1, piece.square[1] + 1])
        end
      end
    end
    if piece.square[0] <= 5 && piece.square[1] <= 5
      lower_right = [piece.square[0] + 2, piece.square[1] + 2]
      lower_right = board.cells[lower_right[1]][lower_right[0]]
      if lower_right != "#"
        if lower_right.color != piece.color && lower_right.char == pn2 
          moves.delete([piece.square[0] + 1, piece.square[1] + 1])
        end
      end
    end
    # 1 to the left or right, and 2 below 
    if piece.square[0] >= 1 && piece.square[1] <= 5 
      lower_left = [piece.square[0] - 1, piece.square[1] + 2]
      lower_left = board.cells[lower_left[1]][lower_left[0]]
      if lower_left != "#" 
        if lower_left.color != piece.color && lower_left.char == pn2 
          moves.delete([piece.square[0], piece.square[1] + 1])
        end
      end
    end

    if piece.square[0] < 7 && piece.square[1] <= 5 
      lower_right = [piece.square[0] + 1, piece.square[1] + 2]
      lower_right = board.cells[lower_right[1]][lower_right[0]]
      if lower_right != "#" 
        if lower_right.color != piece.color && lower_right.char == pn2 
          moves.delete([piece.square[0], piece.square[1] + 1])
        end
      end
    end
  else   
    if piece.square[0] >= 2 && piece.square[1] >= 2
      upper_left = [piece.square[0] - 2, piece.square[1] - 2]
      upper_left = board.cells[upper_left[1]][upper_left[0]] 
      if upper_left != "#"
        if upper_left.color != piece.color && upper_left.char == pn
          moves.delete([piece.square[0] - 1, piece.square[1] - 1])
        end
      end
    end
    if piece.square[0] <= 5 && piece.square[1] >= 2
      upper_right = [piece.square[0] + 2, piece.square[1] - 2]
      upper_right = board.cells[upper_right[1]][upper_right[0]]
      if upper_right != "#"
        if upper_right.color != piece.color && upper_right.char == pn
          moves.delete([piece.square[0] + 1, piece.square[1] - 1])
        end
      end
    end
    # 1 to the left or right, and 2 above 
    if piece.square[0] >= 1 && piece.square[1] >= 2 
      upper_left = [piece.square[0] - 1, piece.square[1] - 2]
      upper_left = board.cells[upper_left[1]][upper_left[0]]
      if upper_left != "#" 
        if lower_left.color != piece.color && upper_left.char == pn
          moves.delete([piece.square[0], piece.square[1] - 1])
        end
      end
    end

    if piece.square[0] < 7 && piece.square[1] >= 2 
    upper_right = [piece.square[0] + 1, piece.square[1] - 2]
      upper_right = board.cells[upper_right[1]][upper_right[0]]
      if upper_right != "#" 
        if upper_right.color != piece.color && upper_right.char == pn 
          moves.delete([piece.square[0], piece.square[1] - 1])
        end
      end
    end
  end
  
  piece.moves = moves
  return filter_moves(piece, board)
end

def pawn_moves(piece, board)
  moves = []
  # diff moves for white and black since they approach from different sides
  if piece.color == "black"
    moves.push([piece.square[0], piece.square[1] + 1]) if piece.square[1] < 7 
    moves.push([piece.square[0], piece.square[1] + 2]) if piece.square[1] == 1
  else
    moves.push([piece.square[0], piece.square[1] - 1]) if piece.square[1] > 0
    moves.push([piece.square[0], piece.square[1] - 2]) if piece.square[1] == 6 
  end

  to_delete = []
  if piece.color == "black"
    moves.each do |move| 
      above = piece.square.clone 
      above[1] += 1
      if board.cells[above[1]][above[0]] != "#"
        to_delete.push([piece.square[0], piece.square[1] + 2]) 
      end
      to_delete.push(move) if board.cells[move[1]][move[0]] != "#"
    end
  else  
    moves.each do |move| 
      above = piece.square.clone 
      above[1] -= 1 
      if board.cells[above[1]][above[0]] != "#"
        to_delete.push([piece.square[0], piece.square[1] - 2])
      end
      to_delete.push(move) if board.cells[move[1]][move[0]] != "#"
    end
  end
  # filter out moves that are occupied
 
  to_delete.each do |out| 
    moves.delete(out)
  end
  # diagonal moves
  if piece.color == "black"
    if piece.square[0] > 0 && piece.square[1] < 7
      diag_left = piece.square.clone
      diag_left[0] -= 1 
      diag_left[1] += 1

      if board.cells[diag_left[1]][diag_left[0]] != "#"
        if board.cells[diag_left[1]][diag_left[0]].color != piece.color 
          moves.push([piece.square[0] - 1, piece.square[1] + 1])
        end
      end
    end
    if piece.square[0] < 7 && piece.square[1] < 7 
      diag_right = piece.square.clone 
      diag_right[0] += 1 
      diag_right[1] += 1

      if board.cells[diag_right[1]][diag_right[0]] != "#"
        if board.cells[diag_right[1]][diag_right[0]].color != piece.color 
          moves.push([piece.square[0] + 1, piece.square[1] + 1])
        end
      end
    end
  else  
    if piece.square[0] > 0 && piece.square[1] > 0 
      diag_left = piece.square.clone
      diag_left[0] -= 1 
      diag_left[1] -= 1

      if board.cells[diag_left[1]][diag_left[0]] != "#"
        if board.cells[diag_left[1]][diag_left[0]].color != piece.color 
          moves.push([piece.square[0] - 1, piece.square[1] - 1])
        end
      end
    end
    if piece.square[0] < 7 && piece.square[1] > 0 
      diag_right = piece.square.clone
      diag_right[0] += 1 
      diag_right[1] -= 1

      if board.cells[diag_right[1]][diag_right[0]] != "#"
        if board.cells[diag_right[1]][diag_right[0]].color != piece.color 
          moves.push([piece.square[0] + 1, piece.square[1] - 1])
        end
      end
    end
  end

  # en passant 
  pn2 = "\u265F"
  pn = "\u2659"
  cords = piece.square.clone # coordinates of square
  if piece.color == "black"
    left = board.cells[4][cords[0] - 1]
    right = board.cells[4][cords[0] + 1]
    if cords[1] == 4 
      if left != "#"
        if left.char == pn2
          # function to handle enpassant move and capture
          $passant_arr[0] += 1
          # condition makes sure that you can only passant at first chance
          if $passant_arr[0] < 2
            moves.push([piece.square[0] - 1, piece.square[1] + 1])
          end
        end
      end
      if right != "#"
        if right.char == pn2 
          $passant_arr[1] += 1 
          if $passant_arr[1] < 2 
            moves.push([piece.square[0] + 1, piece.square[1] + 1])
          end
        end
      end
    end
  elsif piece.color == "white"
    left = board.cells[3][cords[0] - 1]
    right = board.cells[3][cords[0] + 1]
    if cords[1] == 3 
      if left != "#"
        if left.char == pn 
          $passant_arr[2] += 1 
          if $passant_arr[2] < 2 
            moves.push([piece.square[0] - 1, piece.square[1] - 1])
          end
        end
      end
      if right != "#" 
        if right.char == pn 
          $passant_arr[3] += 1 
          if $passant_arr[3] < 2 
            moves.push([piece.square[0] + 1, piece.square[1] - 1]) 
          end
        end  
      end
    end
  end
  piece.moves = moves
  piece.moves = filter_moves(piece, board)
  return piece.moves
end

def draw(board)
  center = "                               "
  print "\n#{center}" # for centering
  row_ind = 0
  board.cells.each do |row| 
    row_ind += 1
    count = 0
    row.each do |cell|
      count += 1 
      cell == "#" ? (print "# ") : (print "#{cell.char} ")
      print "\n#{center}" if count % 8 == 0 && row_ind != 8
    end
  end
  print "\n\n"
end

def check?(king, board) 
  pn = "\u2659"
  pn2 = "\u265F"
  board.cells.each do |row| 
    row.each do |square| 
      if square != "#"
        # special pawn conditions because they only capture diagonally
        if square.color != king.color && square.moves.include?(king.square) && 
        square.char != pn && square.char != pn2
          return true
        end
      end
    end
  end
  return false
end

def checkmate(king, board) 
  check_count = 0
  # look for king in each iteration
  # edit board with each move 
  # run check with the king, and the edited clone board
  king_clone = []
  board.cells.each do |row| 
    row.each do |cell|
      if cell != "#" && cell.color == king.color 
        move_index = 0 
        cell.moves.each do |move|
          # setting the board to original state
          clone = copy_board(board)
          # editing clone board
          clone.cells[cell.square[1]][cell.square[0]] = "#"
          # make a clone of the piece
          clone.cells[move[1]][move[0]] = 
          Piece.new(cell.char, move.clone, [], cell.color) 

          k = "\u2654"
          k2 = "\u265A"
          k_row = 0 
          # searching for the king, to get its square
          if king.color == "black" 
            king_clone = find_king(clone, 2)
          else  
            king_clone = find_king(clone, 1)
          end
          
          if check?(king_clone, clone) 
            check_count += 1
            cell.moves[move_index] = cell.square.clone
          end
          move_index += 1
        end
      end
    end
  end 
  # filtering out those illegal moves
  board.cells.each do |row| 
    row.each do |cell| 
      if cell != "#"
        cell.moves.delete_if {|move| move == cell.square}
      end
    end
  end
  p check_count
end

def copy_board(board)
  clone = Board.new([])
  board.cells.each do |row|
    clone_row = [] 
    row.each do |cell| 
      if cell == "#"
        clone_row.push("#")
      else 
        copy = Piece.new(
        cell.char, cell.square.clone, cell.moves.clone, cell.color)
        clone_row.push(copy)
      end
    end
    clone.cells.push(clone_row)
  end 
  return clone
end

def find_king(board, turn)
  # returns a copy of the king in a board
  k = "\u2654"
  k2 = "\u265A"
  placeholder = Piece.new(k, [], [], nil)
  board.cells.each do |row| 
    row.each do |cell| 
      if cell != "#"
        if turn % 2 == 0 && cell.char == k
          placeholder.square = cell.square 
          placeholder.color = 'black'
        elsif turn % 2 == 1 && cell.char == k2  
          placeholder.square = cell.square 
          placeholder.color = 'white'
        end
      end
    end
  end 
  return placeholder
end

# global, I know, just need a way to see which pawns can passant and not
$passant_arr = [0, 0, 0, 0] # each 0 represents if a pawn can passant or not

def castling(board, turn)
  p "turn: #{turn}"
  r = "\u2656"
  q = "\u2655"
  k = "\u2654"
  k2 = "\u265A"
  q2 = "\u265B"
  r2 = "\u265C"

  top_l = [board.cells[0][0], board.cells[0][1], board.cells[0][2], 
  board.cells[0][3]]
  top_r = [board.cells[0][4], board.cells[0][5], board.cells[0][6], 
  board.cells[0][7]]

  bot_l = [board.cells[7][0], board.cells[7][1], board.cells[7][2], 
  board.cells[7][3]]
  bot_r = [board.cells[7][4], board.cells[7][5], board.cells[7][6], 
  board.cells[7][7]]
  
  if turn % 2 == 0 # for black
    if top_l[0] != "#" && top_l[3] != "#" && top_l[1] == "#" && top_l[2] == "#"
      if top_l[0].color == "black" && top_l[3].color == "black" && 
      top_l[0].char == r && top_l[3].char == q 

        # only allowing castling if it doesnt put king in check/mate
        clone = copy_board(board)
        clone.cells[0][1] = Piece.new(r, [1, 0], [], 'black')
        clone.cells[0][2] = Piece.new(q, [2, 0], [], 'black')
        clone.cells[0][0] = "#"
        clone.cells[0][3] = "#"
        placeholder = find_king(clone, turn) # king placeholder
        show_moves(clone, turn)

        if !check?(placeholder, clone)
          p "Type rq if you'd like to castle rook and queen"
          input = gets.chomp 
          if input == "rq"
            board.cells[0][2] = board.cells[0][0]
            board.cells[0][2].square = [2, 0]
            board.cells[0][1] = board.cells[0][3]
            board.cells[0][1].square = [1, 0]

            board.cells[0][0] = "#"
            board.cells[0][3] = "#"
            castling(board, turn + 1)
            move_piece(board, turn + 1)
          else  
            move_piece(board, turn)
          end
        end
      end
    end
    if top_r[0] != "#" && top_r[3] != "#" && top_r[1] == "#" && top_r[2] == "#"
      if top_r[0].color == "black" && top_r[3].color == "black" && 
      top_r[0].char == k && top_r[3].char == r

        # castling king and rook for black 
        clone = copy_board(board)
        clone.cells[0][5] = Piece.new(r, [5, 0], [], 'black')
        clone.cells[0][6] = Piece.new(k, [6, 0], [], 'black')
        clone.cells[0][4] = "#"
        clone.cells[0][7] = "#"
        placeholder = find_king(clone, turn)
        p "clone: "
        show_moves(clone, turn)

        if !check?(placeholder, clone)
          p "Type rk if you'd like to castle king and rook"
          input = gets.chomp 
          if input == "rk"
            board.cells[0][6] = board.cells[0][4]
            board.cells[0][6].square = [6, 0]
            board.cells[0][5] = board.cells[0][7]
            board.cells[0][5].square = [5, 0]

            board.cells[0][4] = "#"
            board.cells[0][7] = "#"
            castling(board, turn + 1)
            move_piece(board, turn + 1) 
          else  
            move_piece(board, turn)
          end
        end
      end
    end
  else  
    if bot_l[0] != "#" && bot_l[3] != "#" && bot_l[1] == "#" && bot_l[2] == "#"
      if bot_l[0].color == "white" && bot_l[3].color == "white" && 
      bot_l[0].char == r2 && bot_l[3].char == q2 

        clone = copy_board(board)
        clone.cells[7][1] = Piece.new(q, [1, 7], [], 'black')
        clone.cells[7][2] = Piece.new(r, [2, 7], [], 'black')
        clone.cells[7][0] = "#"
        clone.cells[7][3] = "#"
        placeholder = find_king(clone, turn) # king placeholder
        show_moves(clone, turn)

        if !check?(placeholder, turn)
          p "Type rq if you'd like to castle rook and queen"
          input = gets.chomp 
          if input == "rq"
            board.cells[7][2] = board.cells[7][0]
            board.cells[7][2].square = [2, 7]

            board.cells[7][1] = board.cells[7][3]
            board.cells[7][1].square = [1, 7]

            board.cells[7][0] = "#"
            board.cells[7][3] = "#"
            castling(board, turn + 1)
            move_piece(board, turn + 1)
          else  
            move_piece(board, turn)
          end
        end
      end
    end 
    if bot_r[0] != "#" && bot_r[3] != "#" && bot_r[1] == "#" && bot_r[2] == "#"
      if bot_r[0].color == "white" && bot_r[3].color == "white" && 
      bot_r[0].char == k2 && bot_r[3].char == r2

      clone = copy_board(board)
      clone.cells[7][5] = Piece.new(r, [5, 7], [], 'black')
      clone.cells[7][6] = Piece.new(k, [6, 7], [], 'black')
      clone.cells[7][4] = "#"
      clone.cells[7][7] = "#"
      placeholder = find_king(clone, turn) # king placeholder
      show_moves(clone, turn)

        p "Type rk if you'd like to castle king and rook"
        input = gets.chomp 
        if input == "rk"
          board.cells[7][6] = board.cells[7][4]
          board.cells[7][6].square = [6, 7]
          board.cells[7][5] = board.cells[7][7]
          board.cells[7][5].square = [5, 7]

          board.cells[7][4] = "#"
          board.cells[7][7] = "#"
        
          castling(board, turn + 1)
          move_piece(board, turn + 1)
        else  
          move_piece(board, turn)
        end
      end
    end
  end

end

def show_moves(board, turn)
  movables = []
  # list all moves for black
    # the new moves 
  k = "\u2654"
  q = "\u2655"
  r = "\u2656"
  b = "\u2657"
  h = "\u2658"
  pn = "\u2659"
  # unicode symbols for white
  k2 = "\u265A"
  q2 = "\u265B"
  r2 = "\u265C"
  b2 = "\u265D"
  h2 = "\u265E"
  pn2 = "\u265F"

  board.cells.each do |row| 
    row.each do |cell| 
      if cell != "#"
        if cell.char == pn || cell.char == pn2
          pawn_moves(cell, board)
        end 
        if cell.char == h || cell.char == h2 
          cell.moves = knight_moves(cell, board)
        end
        if cell.char == b || cell.char == b2
          cell.moves = bishop_moves(cell, board)
        end
        if cell.char == r || cell.char == r2
          cell.moves = rook_moves(cell, board)
        end
        if cell.char == q || cell.char == q2
          cell.moves = queen_moves(cell, board)
        end
        if cell.char == k || cell.char == k2
          cell.moves = king_moves(cell, board)
        end 
      end
    end
  end  
  board.cells.each do |row| 
    row.each do |cell| 
      if cell != "#"
        if turn % 2 == 0 && cell.color == "black"
          if cell.char == k 
            checkmate(cell, board) 
          end
          movables.push(cell) if cell.moves.count > 0
        end
        if turn % 2 != 0 && cell.color == "white"
          if cell.char == k2  
            checkmate(cell, board)
          end 
          movables.push(cell) if cell.moves.count > 0
        end
      end
    end
  end
  draw(board)
  return movables
end

def promotion(pawn)
  q = "\u2655"
  r = "\u2656"
  b = "\u2657"
  h = "\u2658"

  q2 = "\u265B"
  r2 = "\u265C"
  b2 = "\u265D"
  h2 = "\u265E"

  promotables_b = [b, h, r, q]
  promotables_w = [b2, h2, r2, q2]
  if pawn.color == "black" && pawn.square[1] == 7 || pawn.color == "white" && 
  pawn.square[1] == 0
    p "type 0 for bishop, 1 for knight, 2 for rook, 3 for queen"
    rank = gets.chomp.to_i 
    rank = 3 if rank > 3
    pawn.char = promotables_b[rank]
    pawn.char = promotables_w[rank] if pawn.color == "white"  
  end
end

def save(board, turn)
  file = File.open("save.txt", "r+")
  turn_file = File.open("turn_file.txt", "w+")
  file.write(Marshal.dump(board))
  turn_file.write(turn)

  file.close
  turn_file.close
  exit!
end

def load(board)
  file = File.open("save.txt", "r+")
  turn_file = File.open("turn_file.txt", "r+")
  board_string = ""
  File.foreach("save.txt") { |line| board_string.concat(line)} 
  # last character is turn, get rid of it
  turn = turn_file.read.chomp.to_i
  
  move_piece(Marshal.load(board_string), turn)
end

def move_piece(board, turn)
  movables = show_moves(board, turn)

  # iterate over each piece, only show the ones that can move
  no_goes = 0
  movables.each do |piece|
    if piece.moves.count == 0 
      no_goes += 1
    end
  end
  
  if no_goes == movables.count 
    p "game end"
    exit! 
  end

  index = 0
  movables.each do |m| 
    p "#{index} | #{m.char} | #{m.square} | #{m.moves}"
    index += 1
  end
  p "Which piece do you want to move? (Use the numbers)"
  p "Alternatively, type 'save' or 'load' to do just that (no quotes)"
  choice = gets.chomp
  p choice
  save(board, turn) if choice == "save"
  load(board) if choice == "load"
  choice = choice.to_i
  if choice >= movables.count 
    p "Not in range, defaulting to index #{movables.count - 1}"
    choice = movables.count - 1
  end

  copy = movables[choice].square.clone # store original square
  p "Which move? (moves are numbered from 0 and increasing left to right)"
  coordinates = gets.chomp.to_i

  if coordinates >= movables[choice].moves.count 
    p "Not in range, defaulting to index #{movables[choice].moves.count - 1}"
    coordinates = movables[choice].moves.count - 1
  end

  destination = movables[choice].moves[coordinates]
  p "Piece moved to #{destination}"

  # enforcing en passant capture 
  pn = "\u2659"
  pn2 = "\u265F"
  # the en passant capture is always listed last in moves
  if coordinates == movables[choice].moves.count - 1
    if movables[choice].char == pn
      if $passant_arr[0] == 1
        board.cells[4][movables[choice].square[0] - 1] = "#"
      end
      if $passant_arr[1] == 1 
        board.cells[4][movables[choice].square[0] + 1] = "#"
      end
    elsif movables[choice].char == pn2 
      if $passant_arr[2] == 1 
        board.cells[3][movables[choice].square[0] - 1] = "#"
      end  
      if $passant_arr[3] == 1 
        board.cells[3][movables[choice].square[0] + 1] = "#"
      end
    end
  end

  movables[choice].square = destination

  board.cells[movables[choice].square[1]][movables[choice].square[0]] = 
  movables[choice]

  board.cells[copy[1]][copy[0]] = "#"
  castling(board, turn + 1)

  if movables[choice].char == pn || movables[choice].char == pn2 
    promotion(movables[choice])
  end
  move_piece(board, turn + 1)
end

# unicode pieces for black
k = "\u2654"
q = "\u2655"
r = "\u2656"
b = "\u2657"
h = "\u2658"
pn = "\u2659"
# setting the board with black pieces
board.cells[0][0] = Piece.new(r, [0, 0], [], 'black') # R for rook
board.cells[0][1] = Piece.new(h, [1, 0], [], 'black') # H for horse, knight
board.cells[0][2] = Piece.new(b, [2, 0], [], 'black') # B for bishop
board.cells[0][3] = Piece.new(q, [3, 0], [], 'black') # Q for queen
board.cells[0][4] = Piece.new(k, [4, 0], [], 'black') # K for king
board.cells[0][5] = Piece.new(b, [5, 0], [], 'black') # B for bishop
board.cells[0][6] = Piece.new(h, [6, 0], [], 'black') # H for horse, knight
board.cells[0][7] = Piece.new(r, [7, 0], [], 'black') # R for rook

i = 0
while i < 7
  board.cells[1][i] = Piece.new(pn, [i, 1], [], 'black')
  i += 1
end
# last pawn didnt get made for some reason smh
board.cells[1][7] = Piece.new(pn, [7, 1], [], 'black')

# unicode symbols for white
k2 = "\u265A"
q2 = "\u265B"
r2 = "\u265C"
b2 = "\u265D"
h2 = "\u265E"
pn2 = "\u265F"
# setting the board with white pieces
board.cells[7][0] = Piece.new(r2, [0, 7], [], 'white') # R for rook
board.cells[7][1] = Piece.new(h2, [1, 7], [], 'white') # H for horse, knight
board.cells[7][2] = Piece.new(b2, [2, 7], [], 'white') # B for bishop
board.cells[7][3] = Piece.new(q2, [3, 7], [], 'white') # Q for queen
board.cells[7][4] = Piece.new(k2, [4, 7], [], 'white') # K for king
board.cells[7][5] = Piece.new(b2, [5, 7], [], 'white') # B for bishop
board.cells[7][6] = Piece.new(h2, [6, 7], [], 'white') # H for horse, knight
board.cells[7][7] = Piece.new(r2, [7, 7], [], 'white') # R for rook
# white pawns
i = 0
while i < 7
  board.cells[6][i] = Piece.new(pn2, [i, 6], [], 'white')
  i += 1
end
# smh last pawn wasnt made
board.cells[6][7] = Piece.new(pn2, [7, 6], [], 'white')
# starting the game loop 

# comment out while testing
#move_piece(board, 1)