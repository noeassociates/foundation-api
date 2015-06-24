class Foundation::Runner

  attr_accessor :processors, :before, :after

  def initialize processors
    @processors = processors
    @before = []
    @after = []
  end

  def run request, params
    builders.each_with_object(Hashie::Mash.new) do |b, env|
      b.new(request).build(params, env)
    end
  end

  def builders
    after + processors + before
  end

end
