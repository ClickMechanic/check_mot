module CheckMot

  class Attribute
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def self.resolve(name, value)
      [DateAttribute].lazy.map do |attr|
        attr.try(name, value)
      end.first || value
    end
  end

end
