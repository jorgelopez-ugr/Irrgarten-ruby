require_relative 'player'

class Fuzzy_player < Player

  def initialize(number,intelligence,strength,row,col)
    super(number,intelligence,strength)
  end

  def self.new_fuzzy(otro)
    nueva = new(otro.number,otro.intelligence,otro.strength,otro.row,otro.col)
    otro = nil
    nueva
  end

  def move(direction,validMoves)
    output = nil
    contained = validMoves.include?(direction)

    if (contained && validMoves.size > 0)
      output = Dice.next_step(direction,validMoves,@intelligence)
    else
      validMoves.delete(direction)
      output = Dice.next_step(validMoves[0],validMoves,@intelligence)
    end

    return output
  end

  def attack
    sum_weapons + Dice.intensity(@strength)
  end

  def defensive_energy
    sum_shield + Dice.intensity(@intelligence)
  end

  def to_s
    txt = ""
    txt += " FUZZY"
    txt += super
    txt
  end
end
