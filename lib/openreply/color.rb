module Openreply
  module Color

    # Convert numeric color representation to a string that is used in css
    # It's used in views - graphs
    #
    # @param [Numeric] value
    # @return [String]
    def self.color value
      if !value.is_a? Numeric
        "gray"
      elsif (0 <= value) && (2 > value)
        "pink"
      elsif (2 <= value) && (4 > value)
        "yellow"
      elsif (4 <= value) && (5 >= value)
        "green"
      else
        "gray"
      end
    end

    # Convert numeric color representation to a string that is used in css
    # It's used in views - graphs
    #
    # @param [Numeric] value
    # @return [String]
    def self.color_change value
      if value == :unknown
        "gray"
      elsif value > 0
        "green"
      elsif value < 0
        "pink"
      else
        "yellow"
      end
    end
  end
end
