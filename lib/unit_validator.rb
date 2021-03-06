class UnitValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value
      begin
        value.unit
      rescue ArgumentError => e
        record.errors.add(attribute, options[:message] || "is not a valid unit: #{value.to_s}.", :value => value)
      end
    end
  end
end

