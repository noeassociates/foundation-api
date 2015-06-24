module Foundation

  require 'foundation/null_unit'
  require 'foundation/builders'
  require 'foundation/api'

  autoload :Documentation, 'foundation/documentation'

  @@unit_class ||= 'Foundation::NullUnit'
  @@builders   ||= []

  def self.builders
    @@builders
  end

  def self.builders= value
    @@builders = value
  end

  def self.unit_class
    @@unit_class.constantize
  end

  def self.unit_class= value
    @@unit_class = value.to_s
  end

  def self.config
    yield self if block_given?
  end
end
