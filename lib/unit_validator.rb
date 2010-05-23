require 'ruby-units'

class UnitValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value
      begin
        value.unit
      rescue ArgumentError => e
        record.errors[attribute] << (options[:message] || "is not a valid unit")
      end
    end
  end
end

