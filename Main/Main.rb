# frozen_string_literal: true
require_relative '../Irrgarten/game'
require_relative '../Controller/controller'
require_relative '../UI/textUI'

module Main

  puts "Introduzca el numero de jugadores : "
  n = gets
  n = n.to_i
  game = Game.new(n)
  view = UI::TextUI.new
  controlador = Control::Controller.new(game,view)

  controlador.play
end
