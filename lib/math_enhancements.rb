class Rational
  alias :"old_/" :"/"
  def /(a)
    begin
      send(:"old_/", a)
    rescue TypeError
      Rational(self.numerator, self.denominator * a )
    end
  end

  alias :"old_*" :"*"
  def *(a)
    begin
      send(:"old_*", a)
    rescue TypeError
      # numerator must have gcd() (ie: be an Integer), so modify the denominator instead
      Rational( self.numerator, self.denominator / a )
    end
  end
end