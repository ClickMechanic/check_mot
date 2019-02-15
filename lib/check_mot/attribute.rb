module CheckMot

  class Attribute
    attr_reader :value

    def initialize(name, value)
      @name, @value = name, value
    end

    def self.resolve(name, value)
      [DateAttribute].lazy.map do |attr|
        attr.try(name, value)
      end.first || value
    end
  end

end
