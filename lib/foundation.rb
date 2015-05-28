module Foundation

  require 'foundation/null_unit'
  require 'foundation/builders'

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

  def self.run_builders request, params, *args
    builders_with(*args).each_with_object(Hashie::Mash.new) do |b, env|
      b.new(request).build(params, env)
    end
  end

  def self.builders_with before: [], after: []
    after + builders + before
  end
end
