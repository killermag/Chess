require_relative "pieces.rb"
require 'pry-byebug'

class Chess

  private
  def initialize()
    @heredoc = <<-BAN
   ――――――――――――――――
   a b c d e f g h
    BAN
    @typeone = false 
    @white = Hash.new
    @black = Hash.new
    @board = [["\u265C", "\u265E", "\u265D", "\u265B", "\u265A", "\u265D", "\u265E", "\u265C"],
              ["\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F", "\u265F"],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              ["\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659", "\u2659"],
              ["\u2656", "\u2658", "\u2657", "\u2655", "\u2654", "\u2657", "\u2658", "\u2656"]]


    assign_attributes
    init_hash
    init_board 
    play_loop
  end

  def init_hash
    array = [0,1,6,7]
    array.each do |x|
      e = 0
      while e < 8
        node = @board[x][e]
        if x == 0 || x == 1
          @white[node.name] = node
        else
          @black[node.name] = node
        end
        e += 1
      end
    end
  end

  def assign_attributes
    names = ['Rook','Knight','Bishop','Queen','King','Bishop_2', 'Knight_2',
      'Rook_2']
    @board.each_with_index do |subarray, subarrayindex|
      subarray.each_with_index do |element, eindex|
        if subarrayindex == 1 || subarrayindex == 6
          name = "pawn_#{eindex}"
        elsif subarrayindex == 0 || subarrayindex == 7
          name = names[eindex]
        end
        pos = []
        pos << subarrayindex << eindex
        type = 0 if subarrayindex < 2
        type = 1 if subarrayindex > 5
        p = 2 if subarrayindex == 1 || subarrayindex == 6
        @board[subarrayindex][eindex] = Piece.new(pos, element, type, name, p)
      end
    end
  end

  def init_board 
    @initial_board = Hash.new
    x = ['a','b','c','d','e','f','g','h']
    x.each_with_index do |val,index|
      y = 0
      8.times do 
        @initial_board["#{y+1}#{val}"] = [y,index]
        y += 1 
      end 
    end 
  end

  def display
    color, subarray, e, bool, count = true, 0, 0, true, 9
    @typeone ? subarray = 0 : subarray = -7
    while subarray != 8 && @typeone || subarray != 1 && !@typeone
      print "#{count-=1} |" if bool
      bool = false
      print "\e[43m#{@board[subarray.abs][e].structure} \e[0m" if color
      print "\e[48;5;52m#{@board[subarray.abs][e].structure} \e[0m" if !color
      color ? color = false : color = true
      e += 1
      if e == 8
        !color ? color = true : color = false
        bool,subarray,e = true, subarray + 1,0
        puts ' '
      end
    end
    print @heredoc
  end


  def input

    #######puts "Select your piece in the following way -> 2,4"
    #piece = ["8->row","1->column"]  -(piece[0]-1)
    puts @initial_board
    @piece = gets.chomp
      if @typeone 
        print "nil"
        @piece[0] = (8-@piece[0].to_i).to_s
        @piece = @initial_board[@piece]
        puts @piece
      else 
        print 'Nil'
        puts @piece
        puts "using value #{@initial_board[@piece.to_s]}"
        puts "the value is #{@initial_board[@piece]}"
        @piece = @initial_board[@piece]
        puts @piece
      end


    input if @board[@piece[0]][@piece[1]].structure == ' '
    # Black.type = 1
    # white.type = 0
    if @typeone
      if @board[@piece[0]][@piece[1]].type != 1
        puts 'blacks turn. select a black piece'
        input
      
      end
    elsif !@typeone 
      if @board[@piece[0]][@piece[1]].type != 0 
        puts "It is whites turn"
        input 
      end

    end 

    puts "The piece you picked is #{@board[(@piece[0])][@piece[1]].structure}"
    @current_piece = @board[@piece[0]][@piece[1]]

  end

  def play_loop
    while true  
      display
      input
      logic
      break if checkmate 
      @typeone ? @typeone = false : @typeone = true 
    end
    goodbye
  end

  def goodbye
    puts 'Game ended'
    @typeone ? car = 'Black' : car = 'White'
    puts "#{car} under Checkmate"
  end

  def logic
    puts "Select the coordinate to which you wanna move your selected piece to \nNote: Illegal moves will result in a reprompt"
    get_move

  end

  def check_type(to)
    #check type is only called when the path between the s and e points is clear.
    # Check type checks the type of the current piece and the type of the node at the point you will be moving to
    # ie the type of
    unless to.type == nil
      if to.type == @current_piece.type
        return true
      end
    end
    return false
  end

  def check_move(move)
    if move[0] > @piece[0] && move[1] > @piece[1] ||
       move[0] < @piece[0] && move[1] < @piece[1] ||
       move[0] > @piece[0] && move[1] < @piece[1] ||
       move[0] < @piece[0] && move[1] > @piece[1] ||
       move == @piece

       return true
     else
       return false
     end
  end

  def knight_moves(move)
    if  @piece[0] + 1 == move[0] && @piece[1] + 2 == move[1] ||
        @piece[0] + 2 == move[0] && @piece[1] + 1 == move[1] ||
        @piece[0] + 1 == move[0] && @piece[1] - 2 == move[1] ||
        @piece[0] + 2 == move[0] && @piece[1] - 1 == move[1] ||
        @piece[0] - 1 == move[0] && @piece[1] - 2 == move[1] ||
        @piece[0] - 2 == move[0] && @piece[1] - 1 == move[1] ||
        @piece[0] - 2 == move[0] && @piece[1] + 1 == move[1] ||
        @piece[0] - 1 == move[0] && @piece[1] + 2 == move[1]

      set(move)
    else
       print "Invalid Knight move\n"
       return get_move
    end
  end

  def out_of_world?(move)
    if move[0] > 7 || move[0] < 0 || move[1] > 7 || move[1] < 0
      return true
    else
      return false
    end
  end

  def can_move?(move)
    @board[move[0]][move[1]].type == @current_piece.type ? false : true
  end

  def empty?(move)
     @board[move[0]][move[1]].structure == " " ? true : false
  end

  def p_two(move)
    if @piece[0] + 1 == move[0] ||  @piece[0] + 2 == move[0] && @piece[1] == move[1] && empty?(move)
      @board[@piece[0]][@piece[1]].p = 1
      return true
    elsif @piece[0] + 1 == move[0] && ((@piece[1] + 1 == move[1] || @piece[1] - 1 == move[1]) && can_move?(move))
      @board[@piece[0]][@piece[1]].p = 1
      return true
    else
      return false
    end
  end

  def p_one(move)
    if @piece[0] + 1 == move[0] && @piece[1] == move[1] && empty?(move)
      return true
    elsif @piece[0] + 1 == move[0] && ((@piece[1] + 1 == move[1] || @piece[1] - 1 == move[1]) && can_move?(move))
      return true
    else
      return false
    end
  end

  def zero(move)
    if @current_piece.p == 2
      return p_two(move)
    elsif @current_piece.p == 1
      return p_one(move)
    end
  end

  def pp_two(move)
    if @piece[0] - 1 == move[0] ||  @piece[0] - 2 == move[0] && @piece[1] == move[1] && empty?(move)
      @board[@piece[0]][@piece[1]].p = 1
      return true
    elsif @piece[0] - 1 == move[0] && ((@piece[1] + 1 == move[1] || @piece[1] - 1 == move[1]) && can_move?(move))
      @board[@piece[0]][@piece[1]].p = 1
      return true
    else
      return false
    end
  end

  def pp_one(move)
    if @piece[0] - 1 == move[0] && @piece[1] == move[1] && empty?(move)
      return true
    elsif @piece[0] - 1 == move[0] && ((@piece[1] + 1 == move[1] || @piece[1] - 1 == move[1]) && can_move?(move))
      return true
    else
      return false
    end
  end

  def one(move)
    if @current_piece.p == 2
      return pp_two(move)
    elsif @current_piece.p == 1
      return pp_one(move)
    end

  end

  def pawn(move)
    if @current_piece.type == 0
      return zero(move)
    elsif @current_piece.type == 1
      return one(move)
    else
      return false
    end

  end

  def pawn_moves(move)
    if pawn(move)
      set(move)
    else
      puts "Error"
      return get_move
    end
  end

  def king(move)
    if can_move?(move)
      if @piece[0] - 1 == move[0] && @piece[1] == move[1] ||
      @piece[0] + 1 == move[0] && @piece[1] == move[1] ||
      @piece[0] + 1 == move[0] && @piece[1] + 1 ==  move[1] ||
      @piece[0] - 1 == move[0] && @piece[1] - 1 ==  move[1] ||
      @piece[0] == move[0] && @piece[1] - 1 ==  move[1] ||
      @piece[0] - 1 == move[0] && @piece[1] + 1 ==  move[1] ||
      @piece[0] + 1 == move[0] && @piece[1] - 1 ==  move[1] ||
      @piece[0] == move[0] && @piece[1] + 1 ==  move[1]

      return true
      else
        return false
      end
    else
      return false
    end
  end

  def set(move)

    #set new
    @board[move[0]][move[1]].structure = @board[@piece[1]][@piece[0]].structure
    @board[move[0]][move[1]].type = @board[@piece[1]][@piece[0]].type
    @board[move[0]][move[1]].p = @board[@piece[1]][@piece[0]].p if pawn?
    @board[move[0]][move[1]].name = @board[@piece[1]][@piece[0]].name
    #reset old
    @board[@piece[0]][@piece[1]].structure = " "
    @board[@piece[0]][@piece[1]].type = nil
    @board[@piece[0]][@piece[1]].p = nil if pawn?
    @board[@piece[0]][@piece[1]].name = nil

    #Updating Hash
    if @typeone
      @black[@board[move[0]][move[1]].name] = @board[move[0]][move[1]]
    else
      @white[@board[move[0]][move[1]].name] = @board[move[0]][move[1]]
    end
  end

  def king_moves(move)
    if king(move)
      set(move)
    else
      puts "Error"
      return get_move
    end
  end

  def equal?(start,endd)
    start == endd ? true : false
  end

  def common(move)
    if common_moves(move)
      set(move)
    else
      puts "Error"
      return get_move
    end

  end

  def guard(current,endd,bools)
    if empty?(current) == false
      return true
    elsif bools[0] == true
      return true if current[0] < endd[0] || current[1] < endd[1]
    elsif bools[1] == true
      return true if current[0] > endd[0] || current[1] > endd[1]
    elsif bools[2] == true
      return true if current[0] > endd[0] || current[1] < endd[1]
    elsif bools[3] == true
      return true if current[0] < endd[0] || current[1] > endd[1]
    end

  end

  def commons(x,y,move)
      x > move[0] && y > move[1] ? b = true : b = false
      x < move[0] && y < move[1] ? bo = true : bo = false unless b
      x < move[0] && y > move[1] ? boo = true : boo = false unless b || bo
      x > move[0] && y < move[1] ? booo = true : booo = false unless b || bo || boo
      loop do
        x += 1 if bo || boo
        x -= 1 if b || booo
        y += 1 if bo || booo
        y -= 1 if b || boo
        break if equal?([y,x],move)
        return false if guard([y,x],move,[b,bo,boo,booo])
      end
      if can_move?(move)
        return true
      else
        return false
      end
  end

  def not_commons
    x > move[0] ? b = true : b = false
      x < move[0] ? bo = true : bo = false unless b
      y > move[1] ? boo = true : boo = false unless b || bo
      y < move[1] ? booo = true : booo = false  unless b || bo || boo
      loop do
        x -= 1 if b
        x += 1 if bo
        y -= 1 if boo
        y += 1 if booo
        return false if empty?([x,y]) == false
        break if x == move[0] && y == move[1]
      end

      return true if can_move?(move)
      return false
  end

  def common_moves(move)
    y = @piece[0]
    x = @piece[1]
    #----------------------------------------------------------
    if @piece[0] == move[0] || @piece[1] == move[1]
      return true if not_commons(x,y,move)
      return false
    else
      return true if commons(x,y,move)
      return false
    end
  end


  def queen?(e=@current_piece)
    if e.structure == "\u265A"
      return true
    elsif e.structure == "\u2654"
      return true
    else
      return false
    end
  end

  def bishop?(e=@current_piece)
    if e.structure == "\u265D"
      return true
    elsif e.structure == "\u2657"
      return true
    else
      return false
    end
  end

  def rook?(e=@current_piece)
    if e.structure == "\u265C"
      return true
    elsif e.structure == "\u2656"
      return true
    else
      return false
    end
  end

  def pawn?(e=@current_piece)
    if  e.structure == "\u265F" || e.structure == "\u2659"
      return true
    else
      return false
    end
  end

  def knight?(e=@current_piece)
    if e.structure == "\u265E" || e.structure == "\u2658"
      return true
    else
      return false
    end
  end

  def king?(e=@current_piece, e2=nil)
    unless e2.nil?
      if e2.type != e.type && e.structure == "\u265A" || e.structure == "\u2654"
        return true
      else
        return false
      end
    else
      if  e.structure == "\u265A" || e.structure == "\u2654"
        return true
      else
        return false
      end
    end
  end


  def checkingtype(move)
    if out_of_world?(move) || check_type(@board[move[1]][move[0]])
      print "Error,Try inputting again with correct values for #{@current_piece.structure}!\n"
      return get_move
    else
      if queen? || bishop? || rook?
        return common(move)
      elsif pawn?
        return pawn_moves(move)
      elsif knight?
        return knight_moves(move)
      elsif king?
        return king_moves
      end
    end
  end

  def check_with_type(current,endd)
    if current.structure == "\u2655" || endd.structure == "\u265B"
      return true if current.type != endd.type
      return false
    else
      return false
    end
  end

  def confirm(endd,finish)
    if endd.structure != " " && !check_with_type(endd,finish)
      return false
    else
      return true
    end
  end

  def knight_checkmate(array,initial_x,initial_y)
    a = 2
    b = 1
    t,f = nil, nil
    kar98 = nil
    while true 
      array.push([initial_x+a,initial_y+b]) unless out_of_world?([initial_x+a,initial_y+b])
      array.push([initial_x+b,initial_y+a]) unless out_of_world?([initial_x+b,initial_y+a])
      t = true if t.nil? 
      break if kar98 == 10 
      if t 
        a = -a 
        t = false 
        f = true 
      elsif f 
        a = a.abs 
        b = -b 
        f = false 
        kar98 = true 
      elsif kar98 == true 
        kar98 = 10 if kar98 == true 
        a = -a 
        b  -b 
      end

    end 
    array
  end

  def bishop_checkmate(array,value,initial_x,initial_y)
    top_right = true 
    top_left = false 
    bottom_right = false 
    bottom_left = false 
    x = initial_x 
    y = initial_y 
    while top_left || top_right || bottom_left || bottom_right 
      x += 1 if top_right || bottom_right 
      x -= 1 if bottom_left || top_left
      y += 1 if bottom_left || bottom_right 
      y -= 1 if top_left || top_right 
      array.push([x,y]) unless out_of_world?([x,y])

      if top_right 
        if out_of_world?([x,y]) || !is_empty?([x,y])
           top_right = false
           bottom_right = true 
           x = initial_x
           y = initial_y
        end 
      elsif bottom_right
        if out_of_world?([x,y]) || !is_empty?([x,y])
          bottom_right = false 
          bottom_left = true 
          x = initial_x 
          y = initial_y 
        end
      elsif bottom_left 
        if out_of_world?([x,y]) || !is_empty?([x,y])
          bottom_left = false 
          top_left= true 
          x = initial_x 
          y = initial_y 
        end

      elsif top_left
        top_left = false 
      end
    end 
    array
  end

  def is_empty?(move)
    if out_of_world?(move)
      return nil
    else
      return empty?(move)
    end
  end

  def rook_checkmate(array,value,initial_x,initial_y)
    up = true
    down = false
    right = false
    left = false
    while up || right || left || down
      initial_y -= 1 if up
      initial_y += 1 if down
      initial_x += 1 if right
      initial_x -= 1 if left

      array.push([initial_x,initial_y]) unless out_of_world?([initial_x,initial_y])
      if up 
        
        if out_of_world?([initial_x,initial_y]) or !is_empty?([initial_x,initial_y])
          up = false 
          down = true 
          initial_y = value.pos[0]
        end
      elsif down 
        
        if out_of_world?([initial_x,initial_y]) or !is_empty?([initial_x,initial_y])
          down = false 
          right = true 
          initial_y = value.pos[0]
        end
      elsif right 
        
        if out_of_world?([initial_x,initial_y]) or !is_empty?([initial_x,initial_y])
          right = false 
          left = true 
          initial_x = value.pos[1]
        end
      elsif left 
        left = false 

      end
    end 
    array
  end

  def king_checkmate(array,initial_x,initial_y)

    array.push([initial_x+1,initial_y]) unless out_of_world?([initial_x+1,initial_y])

    array.push([initial_x-1,initial_y]) unless out_of_world?([initial_x-1,initial_y])

    array.push([initial_x,initial_y+1]) unless out_of_world?([initial_x,initial_y+1])

    array.push([initial_x,initial_y-1]) unless out_of_world?([initial_x,initial_y-1])

    array.push([initial_x+1,initial_y+1]) unless out_of_world?([initial_x+1,initial_y+1])

    array.push([initial_x-1,initial_y-1]) unless out_of_world?([initial_x-1,initial_y-1])

    array.push([initial_x+1,initial_y-1]) unless out_of_world?([initial_x+1,initial_y-1])

    array.push([initial_x-1,initial_y+1]) unless out_of_world?([initial_x-1,initial_y+1])

    array

  end

  def pawn_checkmate(array,value,initial_x,initial_y)
    value.type == 1 ? y = -1 : y = 1

    x = 1


    array.push([initial_x+x,initial_y+y]) unless out_of_world?([initial_x+x,initial_y+y])

    array.push([initial_x-x,initial_y+y]) unless out_of_world?([initial_x-x,initial_y+y])

    return array

  end

  def checkmate
    array = []
    @typeone ? hash = @white : hash = @black

      hash.each do |key,value|
        if rook?(value)

          array = rook_checkmate(array,value,value.pos[1],value.pos[0])

        elsif knight?(value)

          array = knight_checkmate(array,value.pos[1],value.pos[0])

        elsif bishop?(value)

          array = bishop_checkmate(array,value,value.pos[1],value.pos[0])

        elsif king?(value)

          array = king_checkmate(array,value.pos[1],value.pos[0])
        elsif queen?(value)
          array = bishop_checkmate(array,value,value.pos[1],value.pos[0])
          array = rook_checkmate(array,value,value.pos[1],value.pos[0])
        elsif pawn?(value)
          array = pawn_checkmate(array,value,value.pos[1],value.pos[0])
        end

        print "#{value.pos} \n"

      end
      if @typeone
        king = @black['King'].pos.reverse
      else
        king = @white['King'].pos.reverse
      end 
      puts "array : #{array}"
      puts "king #{king}"
      kingarray = king_checkmate([], king[0], king[1])
      (array & kingarray).size == kingarray.size ? true : false 
  end

  def get_move
    puts "Enter  1 to change piece"
    move = gets.chomp
    if move[0] == "1" && move[1] == nil 
      input
      return get_move
    end
    if @typeone 
      move[0] = (8-move[0].to_i).to_s  
      move = @initial_board[move].reverse
      puts move
    elsif !@typeone 
      move[0] = (move[0].to_i - 1).to_s  
      move = @initial_board[move].reverse
      puts move
    end

    checkingtype(move)
  end

end
game = Chess.new
