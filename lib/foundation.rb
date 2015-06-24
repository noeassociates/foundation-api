require 'active_support/core_ext/module'

module Foundation

  require 'foundation/null_unit'
  require 'foundation/builders'
  require 'foundation/api'

  autoload :Documentation, 'foundation/documentation'

  mattr_accessor(:builders) { [] }
  mattr_accessor(:updaters) { [] }

  @@unit_class ||= 'Foundation::NullUnit'

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
