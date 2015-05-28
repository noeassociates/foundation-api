require 'foundation/builder'

class Foundation::Builders::AcceptedParamsBuilder < Foundation::Builder

  def run params, env
    env.accepted_params = params
  end

end
