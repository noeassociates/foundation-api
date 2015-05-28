module Foundation
  class Builder

    attr_reader :request

    def initialize request
      @request = request
    end

    def build params, env
      run *(method(:run).arity == 1 ? [params] : [params, env])
    end

    def run *args
    end

  end
end
