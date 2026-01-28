require_relative 'dice'

class LabyrinthCharacter

  def initialize (name,intelligence,strength,health,row,col)
    @name = name
    @intelligence = intelligence
    @strength = strength
    @health = health
    @row = row
    @col = col

  end

  def self.new_copia(otro)
    new(otro.name,otro.intelligence,otro.strength,otro.health,otro.row, otro.col)
  end

  def dead
    return health <= 0
  end

  def to_s
    txt = ""
    txt += "Name: " + @name.to_s + " \n"
    txt += "Inteligencia: " + @intelligence.to_s + " "
    txt += "Fuerza: " + @strength.to_s + " "
    txt += "Salud: " + @health.to_s + " "
    txt += "Posicion: [" + @row.to_s + "," + @col.to_s + "]" + " \n\n"
    txt
  end

  def got_wounded
    @health = @health - 1
  end

  def attack
    return Dice.intensity(@strength)
  end

  def defend(recievedAttack)

    is_dead=dead
    if(!is_dead)
      defensive_energy=Dice.intensity(@intelligence)
      if(defensive_energy < recievedAttack)
        got_wounded
        is_dead = dead

      end
    end
    is_dead
  end

  def set_pos(row,col)
    @row = row
    @col = col
  end

  attr_reader :row
  attr_reader :col
  attr_reader :intelligence
  attr_reader :strength
  attr_reader :name
  attr_accessor :health

end
