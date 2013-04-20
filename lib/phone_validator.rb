#class PhoneValidator < ActiveModel::EachValidator
#  @@default_options = {}
#
#  def self.default_options
#    @@default_options
#  end
#
#  def validate_each(record, attribute, value)
#    options = @@default_options.merge(self.options)
#    unless value =~ /^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$/i
#      record.errors.add(attribute, options[:message] || :invalid)
#    end
#  end
#end