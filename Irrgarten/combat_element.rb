require_relative 'dice'

class CombatElement
  def initialize(effect, uses)
    @effect = effect
    @uses = uses
  end

  def produce_effect()
    if @uses > 0
      @uses = @uses - 1
      return @effect
    else
      return 0
    end
  end

  def discard
    return Dice.discard_element(@uses)
  end

  def to_s
    txt = ""
    txt = "Eff: " + @effect.to_s + " Use:" + @uses.to_s
    txt
  end
end
