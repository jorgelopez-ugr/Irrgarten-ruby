require_relative 'combat_element'
class Weapon < CombatElement

  def initialize (power , uses)
    super(power,uses)
  end

  def produce_effect
    super
  end

  def to_s
    txt = ""
    txt += "Sword stats:"
    txt += super
    txt
  end

  def discard
    super
  end
end
