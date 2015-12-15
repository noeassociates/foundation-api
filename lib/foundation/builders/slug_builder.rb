require 'foundation/builder'

class Foundation::Builders::SlugBuilder < Foundation::Builder

  def run params, env
    name = [params.first_name, params.last_name].join ' '
    name = placeholder_name if name.blank?
    env.slug = name.parameterize '-'
  end

  private

    def placeholder_name
      MissingName.new
    end

    class MissingName < String

      def initialize
        super('visitor')
      end

      def split(*)
        raise NotImplementedError
      end

    end

end
