# frozen_string_literal: true


require_relative 'directions'

require_relative 'game'

require_relative '../UI/textUI'
require_relative '../Controller/controller'

class TestP3
  vista = UI::TextUI.new
  juego = Game.new(1,true)

  100.times do
    vista.show_game(juego.get_game_state)

    #para_depurar
    direction=Directions::DOWN
    end_of_game = juego.next_step(direction)

  end
  vista.show_game(juego.get_game_state)

end