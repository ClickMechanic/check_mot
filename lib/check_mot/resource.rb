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

    private

    attr_reader :source_hash

    def resolved_attribute(name)
      resolved_attributes[name] ||= resolve_attribute(name, @source_hash[name])
    end

    def resolved_attributes
      @_resolved_attributes ||= {}
    end

    def resolve_attribute(name, value)
      attr = Attribute.resolve(name, value)

      case attr
      when Array
        attr.map { |value| resolve_attribute(name, value) }
      when Hash
        Resource.new(attr)
      when Attribute
        attr.value
      else
        value
      end
    end
  end

end
