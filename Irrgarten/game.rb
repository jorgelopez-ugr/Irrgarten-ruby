# frozen_string_literal: true
require_relative 'dice'
require_relative 'monster'
require_relative 'labyrinth'
require_relative 'player'
require_relative 'orientation'
require_relative 'game_state'
require_relative 'game_character'
require_relative 'fuzzy_player'

class Game
  include Orientation
  @@MAX_ROUNDS=10

  def initialize(n_players)
      #determina quien empieza
       @current_player_index=Dice.who_starts(n_players)
      #inicializa el log podria ser @@ pero no es necesario
       @log=""
      #inicializa el array de players
       @players=Array.new(n_players)
      #inicializa los players 1 por 1
       n_players.times do |i|
          @players[i] = Player.new(i, Dice.random_intelligence(), Dice.random_strength())
       end
      #se setea el player que empieza luego es el current al instante inicial
        @current_player=@players.at(@current_player_index)
      #inicializa el array de monsters
        @monsters=Array.new()
      #inicializa la board
        @labyrinth = Labyrinth.new(10,10,4,4)
      #llama al configure_labyrinth para que coloque los elemntos dentro del tablero vacio
        configure_labyrinth
      #se esparcen los jugadores en posiciones semi-aleatorias
        @labyrinth.spread_players(@players)
      end

    # else #inicializacion DEBUGER
    #   #empieza el player 0 y lo inicializa
    #   @current_player_index=0
    #   @log=""
    #   @players=Array.new(n_players)
    #   n_players.times do |i|
    #     @players[i] = Player.new(i, Dice.random_intelligence(), Dice.random_strength())
    #     end
    #   @current_player=@players.at(@current_player_index)
    #   #inicializa el array de monsters pero no creara ningun monstruo (linea comentada)
    #   @monsters=Array.new()
    #   #@monsters[0] = Monster.new_monster("m0", Dice.random_intelligence, Dice.random_strength)
    #   @labyrinth = Labyrinth.new(2,2,0,1)
    #   configure_labyrinth_debug
    #   @labyrinth.spread_players(@players,debuger)

  def finished()
    @labyrinth.have_a_winner()
  end

  def next_step(preferred_direction)

    @log=""
    dead = @current_player.dead
    #si no murio actualiza la direccion
    if(!dead)
      direction = actual_direction(preferred_direction)
      if(direction != preferred_direction)
        log_player_no_orders
      end

      monster = @labyrinth.put_player(direction,@current_player)

      if(monster==nil)
        log_no_monster
      else
        winner=combat(monster)
        manage_reward(winner)
      end

    else
      manage_resurection
    end

    endGame=finished

    if(!endGame)
      next_player
    end

    endGame

  end

  def get_game_state()
    jugadores = ""
    monstruos = ""
    @players.size.times do |i|
      jugadores += @players[i].to_s
    end
    @monsters.size.times do |i|
      monstruos += @monsters[i].to_s + "  "
    end
    GameState.new(@labyrinth.to_s(), jugadores, monstruos,
                  @current_player_index.to_s, finished(), @log)
  end

  private

  #version 1
  # def configure_labyrinth()
  #   # esto genera los bloques en la posicon que le determines
  #   # en algun momento esto podra ser aleatorio pero de momento lo voy a
  #   # dejar de esta forma
  #   @labyrinth.add_block(Orientation::VERTICAL, 1,1,2)
  #   @labyrinth.add_block(Orientation::VERTICAL, 1,2,3)
  #   @labyrinth.add_block(Orientation::HORIZONTAL, 0,1,3)

  #   # esto genera los monster, se les asigna una posicion y se les mete en: laberinto
  #   # matriz monsters y lista monsters con el add_monster
  #   monster1 = Monster.new_monster("Monstruo1", Dice.random_intelligence, Dice.random_strength)
  #   posicion = @labyrinth.random_empty_pos
  #   @labyrinth.add_monster(posicion[0], posicion[1], monster1)
  #   monster1.set_pos(posicion[0], posicion[1])
  #   @monsters.push(monster1)
  # end

    #monster2 = Monster.new_monster("Monstruo_otro", Dice.random_intelligence, Dice.random_strength)
    #posicion2 = @labyrinth.random_empty_pos
    #@labyrinth.add_monster(posicion2[0], posicion2[1], monster2)
    #monster1.set_pos(posicion2[0], posicion2[1])
    #@monsters.push(monster2)

  # #solo para pruebas
  # def configure_labyrinth_debug()
  #   @labyrinth.add_block(Orientation::HORIZONTAL, 1,1,1)

  #   monster1 = Monster.new_monster("Monstruo1", Dice.random_intelligence, Dice.random_strength)
  #   posicion = @labyrinth.random_empty_pos
  #   @labyrinth.add_monster(posicion[0], posicion[1], monster1)
  #   monster1.set_pos(posicion[0], posicion[1])
  #   @monsters.push(monster1)

  # end

  def configure_labyrinth()
    for i in 1..15
      @labyrinth.add_block(Orientation::HORIZONTAL,Dice.random_pos(10),Dice.random_pos(10),1)
    end

    num_monsters = Dice.random_pos(4) + 1
    num_monsters.times do |i|
      # monstruo = Monster.new_monster("Monster " + i.to_s,Dice.random_strength,Dice.random_intelligence)
      monstruo = Monster.new_monster("Monster " + i.to_s,100,100)

      # puts monstruo.class

      posicion = @labyrinth.random_empty_pos
      @labyrinth.add_monster(posicion[0],posicion[1],monstruo)
      monstruo.set_pos(posicion[0],posicion[1])
      @monsters.push(monstruo)
    end
  end

  #el siguiente en el orden depende del que empieza (aleatorio)
  def next_player()
    @current_player_index=(@current_player_index+1)%@players.size()
    @current_player=@players.at(@current_player_index)
  end

  def actual_direction(preferred_direction)
    current_row= @current_player.row
    current_col= @current_player.col
    valid_moves=@labyrinth.valid_moves(current_row,current_col)
    output=@current_player.move(preferred_direction,valid_moves)
    output

  end

  def combat(monster)
    rounds = 0
    winner = GameCharacter::PLAYER
    player_attack = @current_player.attack()
    lose = monster.defend(player_attack)
    while !lose && rounds<@@MAX_ROUNDS
      winner = GameCharacter::MONSTER
      rounds += 1
      monster_attack = monster.attack()
      lose = @current_player.defend(monster_attack)
      if !lose
        player_attack = @current_player.attack()
        winner = GameCharacter::PLAYER
        lose = monster.defend(player_attack)
      end
    end
    self.log_rounds(rounds, @@MAX_ROUNDS)
    winner
  end

  def manage_reward(winner)
    if winner == GameCharacter::PLAYER
      @current_player.receive_reward()
      self.log_player_won()
    else
      self.log_monster_won()
    end
  end

  def manage_resurection()
    resurrect=Dice.resurrect_player
    if( resurrect )
      @current_player.resurrect
      fuzzy = Fuzzy_player.new_fuzzy(@current_player)
      @players[@current_player_index] = fuzzy
      self.log_resurrected
    else
      self.log_player_skip_turn
    end
  end

  def log_player_won()
    @log+="GANADOR\n"
  end

  def log_monster_won()
    @log+="MONSTER WON\n"
  end

  def log_resurrected()
    @log+="HA RESUCITADO COMO FUZZY\n"
  end

  def log_player_skip_turn()
    @log+="PIERDE EL TURNO PORQUE ESTA MUERTO\n"
  end

  def log_player_no_orders()
    @log+="No fue posible seguir las instrucciones del jugador humano\n"
  end

  def log_no_monster()
    @log+="El jugador se ha movido a una celda vacía o no le ha sido posible moverse\n"
  end

  def log_rounds(rounds, max)
    @log+="Se han producido un total de " + rounds.to_s + " de " + max.to_s + " rondas de combate\n"
  end

end
