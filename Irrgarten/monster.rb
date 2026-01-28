require_relative 'dice'
require_relative 'labyrinth_character'

class Monster < LabyrinthCharacter
  @@INITIAL_HEALTH=5.to_f

  def initialize(name,intelligence,strength,health,row,col)
    super(name,intelligence,strength,health,row,col)
  end

  def self.new_monster(name,intelligence,strength)
    new(name,intelligence,strength,@@INITIAL_HEALTH,-1,-1)
  end

  def dead
    super
  end

  def attack
    super
  end

  def defend(recievedAttack)
    super
  end

  def set_pos(row,col)
    super
  end

  def to_s
    # cadena = "Monster[" + @name.to_s + ",Inteligencia:" + @intelligence.to_s + ",Fuerza:" + @strength.to_s +
    #   ",Salud:" + @health.to_s  + ",Posicion[" + @row.to_s + "," + @col.to_s + "]]"
    # cadena
    super
  end

  def got_wounded
    super
  end

  private :got_wounded
  private_class_method :new
end
