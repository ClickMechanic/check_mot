module CheckMot

  class DateAttribute < Attribute

    ATTRIBUTE_REGEX = /_date$/
    DATE_REGEX = /^\d{4}.\d{2}.\d{2}$/
    TIME_REGEX = /^\d{4}.\d{2}.\d{2} \d{2}:\d{2}:\d{2}$/

    def self.try(name, value)
      return unless name.to_s.match(/_date$/)

      new(value)
    end

    def value
      raw_val = super
      case raw_val
      when DATE_REGEX
        Date.parse(raw_val)
      when TIME_REGEX
        Time.parse(raw_val)
      else
        raw_val
      end
    end
  end

end
