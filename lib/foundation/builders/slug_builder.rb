require 'foundation/builder'

class Foundation::Builders::SlugBuilder < Foundation::Builder

  def run params, env
    name = [params.first_name, params.last_name].join ' '
    env.slug = name.parameterize '-'
  end

end
