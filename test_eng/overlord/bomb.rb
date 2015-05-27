class BombError < RuntimeError
end

class InvalidTransition < BombError
end

class WrongCode < BombError
end

class InvalidCode < BombError
end

class Exploded < BombError
end

class Bomb
  attr_accessor :state

  def initialize
    @state = :unset
  end

  def boot(activation_code, deactivation_code)
    fail InvalidTransition, "Bomb is not unset" unless @state == :unset
    validate_codes(activation_code, deactivation_code)
    @state = :booted
  end

  def activate(code)
    fail InvalidTransition, "Bomb is not booted" unless @state == :booted
    if code != @activation_code
      fail WrongCode, "That's not the right activation code"
    end

    @state = :active
    @try_count = 0
  end

  def deactivate(code)
    fail InvalidTransition, "Bomb is not active" unless @state == :active
    fail_deactivation if code != @deactivation_code

    @state = :defused
  end

  private

  def validate_codes(activation_code, deactivation_code)
    activation_code = default_code_fix(activation_code, "1234")
    deactivation_code = default_code_fix(deactivation_code, "0000")

    range_check(activation_code, deactivation_code)

    @activation_code = activation_code
    @deactivation_code = deactivation_code
  end

  def default_code_fix(code, default)
    code = default if !code || code.empty?
    code
  end

  def range_check(activation_code, deactivation_code)
    return if in_range(activation_code) && in_range(deactivation_code)
    fail InvalidCode, "The codes used to configre the bomb are invalid"
  end

  def in_range(code)
    /^[0-9]{4}$/.match(code)
  end

  def fail_deactivation
    @try_count += 1
    if @try_count == 3
      @state = :detonated
      fail Exploded, "The bomb exploded (Terrorists Win)"
    else
      fail WrongCode, "That's not the right deactivation code"
    end
  end
end
