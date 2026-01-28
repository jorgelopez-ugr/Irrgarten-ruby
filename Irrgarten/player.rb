require_relative 'shield'
require_relative 'weapon'
require_relative 'labyrinth_character'

class Player < LabyrinthCharacter

  attr_reader :row, :col, :number

  @@MAX_WEAPONS=2
  @@MAX_SHIELDS=3
  @@INITIAL_HEALTH=10
  @@HITS_2_LOSE=3

  def initialize(number, intelligence, strength)
    @number=number
    @consecutive_hits=0
    @weapons = Array.new()
    @shields = Array.new()

    super("Player "+number.to_s,intelligence,strength,@@INITIAL_HEALTH.to_f,0,1)
  end

  def resurrect()
    @weapons.clear
    @shields.clear
    @health = @@INITIAL_HEALTH
    self.reset_hits
  end

  def set_pos(row, col)
    super(row,col)
  end

  def dead()
    super
  end

  def move(direction, valid_moves)
    size = valid_moves.size
    contained = valid_moves.include?(direction)
    if(size > 0 && !contained)
      firstElement = valid_moves[0]
      return firstElement
    else
      return direction
    end
  end
  #se supone que hacen las veces de override
  def attack()
    @strength+self.sum_weapons()
  end

  def defend(received_attack)
    manage_hit(received_attack)
  end

  def receive_reward()
    w_reward = Dice.weapons_reward
    s_reward = Dice.shields_reward
    w_reward.times do |i|
      wnew = Weapon.new(Dice.weapon_power, Dice.uses_left)
      self.receive_weapon(wnew)
    end
    s_reward.times do |i|
      snew = Shield.new(Dice.shield_power, Dice.uses_left)
      self.receive_shield(snew)
    end
    extra_health = Dice.health_reward()
    @health += extra_health
  end

  def to_s()
    # armas = ""
    # @weapons.size.times do |i|
    #   armas += @weapons.at(i).to_s + "  "
    # end
    # shield = ""
    # @shields.size.times do |i|
    #   shield += @shields.at(i).to_s + "  "
    # end
    # texto = @name.to_s + "(I:" + @intelligence.to_s + " ,F:" + @strength.to_s + " ,S:"+@health.to_s
    # texto += " Posicion:[" +self.row.to_s + "]["+ self.col.to_s + "] )\n"
    # texto +=  "Armas: " + armas + "\n"
    # texto += "Escudos: " + shield + "\n\n"

    # texto
    txt = ""
    txt += "PLAYER: "
    txt += super
    txt
  end

  private

  def receive_weapon(w)
    @weapons.delete_if {|i| i.discard}

    size = @weapons.size()
    if size<@@MAX_WEAPONS
      @weapons << w
    end
  end

  def receive_shield(s)
    @shields.delete_if {|i| i.discard}
    size = @shields.size

    if size < @@MAX_SHIELDS
      @shields << s
    end
  end

  def new_weapon()
    Weapon.new(Dice.weapon_power, Dice.uses_left)
  end

  def new_shield()
    Shield.new(Dice.shield_power, Dice.uses_left)
  end

  def sum_weapons()
    sum=0
    @weapons.size().times do |i|
      sum+=@weapons.at(i).produce_effect()
    end
    sum
  end

  def sum_shield()
    sum=0
    @shields.size().times do |i|
      sum+=@shields.at(i).produce_effect()
    end
    sum
  end

  def defensive_energy()
    return @intelligence+sum_shield()
  end

  def manage_hit(received_attack)
    defense = self.defensive_energy
    if defense < received_attack
      self.got_wounded()
      self.inc_consecutive_hits
    else
      self.reset_hits
    end
    if (@consecutive_hitsits == @@HITS_2_LOSE ) || ( self.dead() )
      self.reset_hits()
      lose = true
    else
      lose = false
    end
    lose
  end

  def reset_hits()
    @consecutive_hits=0
  end

  def got_wounded()
    super
  end

  def inc_consecutive_hits()
    @consecutive_hits+=1
  end

end
