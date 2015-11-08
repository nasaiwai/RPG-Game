#==============================================================================
# Battle-ending
#------------------------------------------------------------------------------
# This class displays gold icon instead of letter G at the end of battle
#
#------------------------------------------------------------------------------
# author: Nasa Iwai
# date: September 10th, 2015
#==============================================================================

class Window_Gold < Window_Base
  def refresh
    contents.clear
    draw_currency_value(value, currency_unit, 4, 0, contents.width - 25)
  end
  def currency_unit
    draw_icon(361, contents.width - 23, -1, true)
  end
end
