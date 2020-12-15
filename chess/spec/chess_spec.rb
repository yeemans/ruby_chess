require '../lib/chess.rb'

describe "#draw" do 
  it "prints an accurate representation of the board" do 
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8
    board = Board.new(board)
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
    expect { draw(board) }.to output( 
                              
                              "
                               ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖ 
                               ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙ 
                               # # # # # # # # 
                               # # # # # # # # 
                               # # # # # # # # 
                               # # # # # # # # 
                               ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟ 
                               ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜ \n\n").to_stdout
  end
end

describe "#pawn_moves" do  
  it "gives black pawns two moves at the start" do
    pn = "\u2659"
    pn2 = "\u265F"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[1][0] = Piece.new(pn, [0, 1], [], 'black')
    expect(pawn_moves(board.cells[1][0], board)).to eql([[0, 2], [0, 3]])
  end
  it "gives black pawns one move if not at starting position" do
    pn = "\u2659"
    pn2 = "\u265F"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[2][0] = Piece.new(pn, [0, 2], [], 'black')
    expect(pawn_moves(board.cells[2][0], board)).to eql([[0, 3]])
  end
  it "gives black pawns diagonal captures" do 
    pn = "\u2659"
    pn2 = "\u265F"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[1][2] = Piece.new(pn, [2, 1], [], 'black')
    board.cells[2][1] = Piece.new(pn2, [1, 2], [], 'white')
    board.cells[2][3] = Piece.new(pn2, [3, 2], [], 'white')
    expect(pawn_moves(board.cells[1][2], board)).to eql(
    [[2, 2], [2, 3], [1, 2], [3, 2]])
  end
  it "does not let black pawn capture other black pieces" do
    pn = "\u2659"
    pn2 = "\u265F"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[1][2] = Piece.new(pn, [2, 1], [], 'black')
    board.cells[2][1] = Piece.new(pn2, [1, 2], [], 'black')
    board.cells[2][3] = Piece.new(pn2, [3, 2], [], 'black')
    board.cells[3][2] = Piece.new(pn2, [2, 3], [], 'white')
    expect(pawn_moves(board.cells[1][2], board)).to eql(
    [[2, 2]])
  end
  it "gives white pawns two moves at the start" do
    pn = "\u2659"
    pn2 = "\u265F"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[6][0] = Piece.new(pn2, [0, 6], [], 'white')
    expect(pawn_moves(board.cells[6][0], board)).to eql([[0, 5], [0, 4]])
  end
  it "allows white pawn captures, also only 1 move when not starting" do 
    pn = "\u2659"
    pn2 = "\u265F"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[4][4] = Piece.new(pn2, [4, 4], [], 'white')
    board.cells[3][3] = Piece.new(pn, [3, 3], [], 'black')
    board.cells[3][5] = Piece.new(pn, [5, 3], [], 'black')
    expect(pawn_moves(board.cells[4][4], board)).to eql(
    [[4, 3], [3, 3], [5, 3]])
  end
end

describe "#knight_moves" do 
  it "lets knight move and capture correctly" do
    pn = "\u2659"
    pn2 = "\u265F"
    h = "\u2658"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[3][3] = Piece.new(h, [3, 3], [], "black")
    # [2, 1] move is blocked, since you cannot capture a piece of your color
    board.cells[1][2] = Piece.new(pn, [2, 1], [], "black")
    # [4, 1] move isn't blocked, piece here can be captured
    board.cells[1][4] = Piece.new(pn2, [4, 1], [], "white")

    expect(knight_moves(board.cells[3][3], board)).to eql(
    [[4, 1], [1, 2], [5, 2], [1, 4], [5, 4], [2, 5], [4, 5]])
  end
end

describe "#bishop_moves" do 
  it "lets bishop move and capture correctly" do 
    pn = "\u2659"
    pn2 = "\u265F"
    b = "\u2657"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[3][3] = Piece.new(b, [3, 3], [], "black")
    # piece that can be captured 
    board.cells[1][5] = Piece.new(pn2, [5, 1], [], "white")
    # piece that cannot be captured 
    board.cells[1][1] = Piece.new(pn, [1, 1], [], "black")
    # [4, 4] can be captured
    board.cells[4][4] = Piece.new(pn2, [4, 4], [], "white")
    # [2, 4] cannot be captured 
    board.cells[4][2] = Piece.new(pn, [2, 4], [], "black")
    # from this spot, bishop has 4 moves
    expect(bishop_moves(board.cells[3][3], board).count).to eql(4)
  end
end

describe "#rook_moves" do 
  it "lets rook move and capture correctly" do 
    pn = "\u2659"
    pn2 = "\u265F"
    r = "\u2656"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[3][3] = Piece.new(r, [3, 3], [], "black")
    # [1, 3] can be captured
    board.cells[3][1] = Piece.new(pn2, [1, 3], [], "white")
    # [5, 3] cannot be captured 
    board.cells[3][5] = Piece.new(pn, [5, 3], [], "black")
    # [3, 1] can be captured
    board.cells[1][3] = Piece.new(pn2, [3, 1], [], "white")
    # rook has 9 moves in this test board
    expect(rook_moves(board.cells[3][3], board).count).to eql(9)
  end
end

describe "#queen_moves" do 
  it "lets queen move and capture correctly" do 
    pn = "\u2659"
    pn2 = "\u265F"
    q = "\u2655" 
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)

    board.cells[3][3] = Piece.new(q, [3, 3], [], "black")
    # [1, 3] can be captured
    board.cells[3][1] = Piece.new(pn2, [1, 3], [], "white")
    # [5, 3] cannot be captured 
    board.cells[3][5] = Piece.new(pn, [5, 3], [], "black")
    # [3, 1] can be captured
    board.cells[1][3] = Piece.new(pn2, [3, 1], [], "white")
    # [3, 5] can be captured 
    board.cells[5][3] = Piece.new(pn, [3, 5], [], "black")
    # [5, 1] cant be captured 
    board.cells[1][5] = Piece.new(pn, [5, 1], [], "black")
    # [1, 1] can be captured 
    board.cells[1][1] = Piece.new(pn2, [1, 1], [], "white")
    # [5, 5] cant be captured 
    board.cells[5][5] = Piece.new(pn, [5, 5], [], "black")
    # [1, 5] can be captured
    board.cells[5][1] = Piece.new(pn2, [1, 5], [], "white")
    expect(queen_moves(board.cells[3][3], board).count).to eql(12)
  end
end

describe "#king_moves" do 
  it "lets black king move correctly, taking check into account" do
    pn = "\u2659"
    pn2 = "\u265F"
    k = "\u2654"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[3][3] = Piece.new(k, [3, 3], [], "black")
    board.cells[5][5] = Piece.new(pn2, [5, 5], [], "white")
    board.cells[5][1] = Piece.new(pn2, [1, 5], [], "white")
    #board.cells[5][4] = Piece.new(pn2, [4, 5], [], "white")
    board.cells[5][3] = Piece.new(pn2, [3, 5], [], "white")
    draw(board)
    
    expect(king_moves(board.cells[3][3], board).count).to eql(6)
  end

  it "lets white king move correctly, taking check into account" do 
    pn = "\u2659"
    pn2 = "\u265F"
    k2 = "\u265A"
    board = []
    board.push(['#', '#', '#', '#', '#', '#', '#', '#']) while board.count < 8 
    board = Board.new(board)
    board.cells[3][3] = Piece.new(k2, [3, 3], [], "white")
    #board.cells[1][4] = Piece.new(pn, [4, 1], [], "black")
    board.cells[1][5] = Piece.new(pn, [5, 1], [], "black")
    board.cells[1][1] = Piece.new(pn, [1, 1], [], "black")
    board.cells[1][3] = Piece.new(pn, [3, 1], [], "black")
    draw(board)
    expect(king_moves(board.cells[3][3], board).count).to eql(6)
  end

end