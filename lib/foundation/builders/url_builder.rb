require 'uri'
require 'foundation/builder'

class Foundation::Builders::UrlBuilder < Foundation::Builder

  def run params, env
    env.url = URI.join("http://#{env.slug}.#{host}").to_s if env.slug
  end

  private

    def host
      # TODO: This only works for TLDs with length of 1
      request.host.split('.').last(2).join('.')
    end

end
