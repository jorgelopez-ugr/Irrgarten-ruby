# frozen_string_literal: true
require_relative 'weapon'
require_relative 'shield'
require_relative 'orientation'
require_relative 'game_state'
require_relative 'dice'
require_relative 'game_character'
require_relative 'directions'
require_relative 'player'
require_relative 'game'
require_relative 'monster'
require_relative 'labyrinth'

class TestP2
  puts "Creo el monstruo m1 :"
  m1 = Monster.new_monster("m1", Dice.random_intelligence, Dice.random_strength)
  puts m1.to_string()



  puts "----------Monster----------"
  puts "Create monster m1:"
  m1 = Monster.new_monster("m1", Dice.random_intelligence, Dice.random_strength)
  puts m1.to_string
  puts "Set position to (1, 3):"
  m1.set_pos(1, 3)
  puts m1.to_string
  puts "Attack:"
  puts m1.attack
  m1.defend(40)
  puts m1.dead ? "It's dead" : "It's not dead"
  puts m1.to_string
  puts "----------------------------"

  puts "---------Player-----------"
  puts "Create player p1:"
  p1 = Player.new('1',Dice.random_intelligence, Dice.random_strength)
  puts p1.to_string
  puts "Attack:"
  puts p1.attack
  puts p1.to_string
  puts "Defend:"
  puts p1.defend(100)
  puts p1.dead ? "It's dead" : "It's not dead"
  puts p1.to_string
  p1.resurrect
  puts p1.to_string
  puts "----------------------------"

  puts "--------Labyrinth----------"
  puts "Create labyrinth l1:"
  l1 = Labyrinth.new(3, 3, 2, 2)
  puts l1.to_string
  puts "Add monster m1 at position (1, 1):"
  l1.add_monster(1, 1, m1)
  puts l1.to_string
  puts "Random empty positions:"
  20.times do
    pos = l1.random_empty_pos
    puts "\nPosition: #{pos[0]}, #{pos[1]}\n"
  end
  puts "----------------------------"

  puts "------------Game------------"
  puts "----------------------------"

end