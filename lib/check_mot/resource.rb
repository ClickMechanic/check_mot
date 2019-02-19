module CheckMot

  class Resource
    def initialize(source_hash)
      @source_hash = source_hash
    end

    def respond_to_missing?(name, include_private = false)
      super || source_hash.keys.include?(name)
    end

    def method_missing(name, *args)
      super unless source_hash.keys.include?(name)
      resolved_attribute(name)
    end

    def inspect
      # prevents extraneous output in the console:
      to_s
    end

    private

    attr_reader :source_hash

    def resolved_attribute(name)
      resolved_attributes[name] ||= resolve_attribute(name, source_hash[name])
    end

    def resolved_attributes
      @_resolved_attributes ||= {}
    end

    def resolve_attribute(name, value)
      attribute = Attribute.resolve(name, value)

      case attribute
      when Array
        attribute.map { |value| resolve_attribute(name, value) }
      when Hash
        Resource.new(attribute)
      when Attribute
        attribute.value
      else
        value
      end
    end
  end

end
