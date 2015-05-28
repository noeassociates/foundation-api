require 'uri'
require 'foundation/builder'

class Foundation::Builders::UrlBuilder < Foundation::Builder

  def run params, env
    env.url = URI.join("http://#{env.slug}.#{request.host}").to_s if env.slug
  end

end
