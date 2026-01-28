require_relative 'combat_element'

class Shield < CombatElement

  def initialize (protection , uses)
    super(protection, uses)
  end

  def produce_effect
    super
  end

  def to_s
    txt = ""
    txt += "Shield stats:"
    txt += super
    txt
  end

  def discard
    super
  end

end
