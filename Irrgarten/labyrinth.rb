class Labyrinth
  @@BLOCK_CHAR ='X'
  @@EMPTY_CHAR = '-'
  @@MONSTER_CHAR = 'M'
  @@COMBAT_CHAR = 'C'
  @@EXIT_CHAR = 'E'
  @@ROW=0
  @@COL=1

  def initialize(n_rows, n_cols, exit_row, exit_col)
    @n_rows =n_rows
    @n_cols = n_cols
    @exit_row = exit_row
    @exit_col = exit_col
    @labyrinth = Array.new(@n_rows){Array.new(@n_cols, @@EMPTY_CHAR)}
    @labyrinth[exit_row][exit_col]=@@EXIT_CHAR
    @monsters =Array.new(@n_rows){Array.new(@n_cols,nil)}
    @players =Array.new(@n_rows){Array.new(@n_cols,nil)}

  end
  # se le pasa -1 como valor arbitrario que no contará para el computo
  # ya que no tiene un old_row ni un old_col
  def spread_players (players)
    # if(debuger)
    #   pos=random_empty_pos
    #   put_player_2D(-1,-1,1,0,players[0])

    # else
         players.size().times do |i|
           p=players.at(i) #metes el player en la lista
           pos=random_empty_pos
           put_player_2D(-1,-1,pos[@@ROW],pos[@@COL],p)
           #con el put player 2D lo "ponemos en laberinto" y por tanto
           # todo el juego conoce que ahi hay un player
         end
    # end
  end

  #si hay algo en la casilla de salida que sea distinto
  # del caracter de salida quiere decir que hay un player
  # luego tenemos un ganador
  def have_a_winner
    @labyrinth[@exit_row][@exit_col]!=@@EXIT_CHAR
  end


  def to_s
    tablero = "Interfaz del laberinto: \n\n"
    @n_rows.times do |i|
      @n_cols.times do |j|
        tablero += @labyrinth[i][j].to_s + " "
      end
      tablero += "\n"
    end
    return tablero
  end

  #añade en laberinto, en matriz monsters y en la posicion del monster
  def add_monster(row,col,monster)
    if (pos_OK(row,col))
      if(empty_pos(row,col))
        @labyrinth[row][col]=@@MONSTER_CHAR
        @monsters[row][col]=monster
        monster.set_pos(row,col)
      end
    end
  end


  def put_player(direction, player)
    old_row=player.row
    old_col=player.col

    new_pos=dir_2_pos(old_row,old_col,direction)
    monster= put_player_2D(old_row,old_col,new_pos[@@ROW],new_pos[@@COL],player)

    monster

  end

  def add_block(orientation,start_row,start_col,length)
    #se determina el crecimiento, si es vertical aumentaran solo las filas
    if orientation == Orientation::VERTICAL
      inc_row = 1
      inc_col = 0
    else #si es horizontal solo las columnas
      inc_row = 0
      inc_col = 1
    end

    row = start_row
    col = start_col
    #se le pasa como parametro una longitud de bloque
    while pos_OK(row, col) && empty_pos(row, col) && (length > 0)
      @labyrinth[row][col] = @@BLOCK_CHAR
      length -= 1
      row += inc_row # esto hace que crezca solo en la direccion que queremos
      col += inc_col # ya que la otra sera 0 y por tanto no variara.
    end
  end
  # output es un array de 2 direcciones
  # si se puede pisar en los alrededores del player
  # se dice que es un movimiento válido y estará almacenado en
  # este array
  def valid_moves(row,col)
    output = Array.new
    if can_step_on(row+1, col)
      output << Directions::DOWN
    end
    if can_step_on(row-1, col)
      output << Directions::UP
    end
    if can_step_on(row, col+1)
      output << Directions::RIGHT
    end
    if can_step_on(row, col-1)
      output << Directions::LEFT
    end
    output
  end

  private

  def pos_OK(row,col)
      return (0<=row && row<@n_rows && 0<=col && col<@n_cols)
  end

  def empty_pos (row,col)
      return @labyrinth[row][col]==@@EMPTY_CHAR
  end

  def monster_pos(row,col)
      return @labyrinth[row][col]==@@MONSTER_CHAR
  end

  def exit_pos(row,col)
    return @labyrinth[row][col]==@@EXIT_CHAR
  end

  def combat_pos(row,col)
    return @labyrinth[row][col]==@@COMBAT_CHAR
  end

  # Se dice que es casilla en la que puede pisar
  # la que esta dentro de los limites, esta vacia o es la salida
  def can_step_on(row,col)
    if(pos_OK(row,col))
      if(empty_pos(row,col))
        return true

      elsif (exit_pos(row,col))
        return true

      elsif (monster_pos(row,col))
        return true
      end

    else
      return false
    end
  end

  # cuando abandone la casilla si deja una M de monster o la deja empty
  # se le llama en cada movimiento
  def update_old_pos(row,col)
    if (pos_OK(row,col))
      if(combat_pos(row,col))
        @labyrinth[row][col]=@@MONSTER_CHAR
      else
        @labyrinth[row][col]=@@EMPTY_CHAR
      end
    end
  end

  def dir_2_pos(row,col,direction)
    output = Array.new(2)
    output[0] = row
    output[1] = col
    if (direction == Directions::LEFT)
      output[1] = col-1

    elsif (direction == Directions::RIGHT)
      output[1] = col+1

    elsif (direction == Directions::UP)
      output[0] = row-1

    elsif (direction == Directions::DOWN)
      output[0] = row+1
    end

    output
  end

  def random_empty_pos
    i=Dice.random_pos(@n_rows)
    j=Dice.random_pos(@n_cols)
    #intere hasta que encuentre una posicion valida
    until empty_pos(i,j)
      i=Dice.random_pos(@n_rows)
      j=Dice.random_pos(@n_cols)
    end
    #lo metemos en un array para entregarlo
    output = Array.new(2)
    output[0] = i
    output[1] = j

    return output
  end

  public :random_empty_pos #publico mientras debugeo
  #funciona como actualizandolo en todas partes, laberinto, matriz players, y valor del player
  def put_player_2D(old_row, old_col, row, col, player)
    output = nil
    # si puede ir a esa posicion
    if can_step_on(row, col)
      #if pos_OK(old_row, old_col) no seria necesario
        p = @players[old_row][old_col]
        if p == player
          self.update_old_pos(old_row, old_col)
          @players[old_row][old_col] = nil
        end
      #end
      monster_pos = self.monster_pos(row, col) #comprueba si hay monstruo en esa posicion
      if monster_pos # si es posicion monster lo pone en combate y devuelve los valores del monster
        @labyrinth[row][col] = @@COMBAT_CHAR
        output = @monsters[row][col]
      else
        number = player.number
        @labyrinth[row][col] = number #el numero del player en el laberinto
      end
      @players[row][col] = player #lo añade en la matriz de players
      player.set_pos(row, col) #modifica el valor del player en si
    end
    output #si no entro en el monster_pos pues devolvera nulo (nil)
  end
end
