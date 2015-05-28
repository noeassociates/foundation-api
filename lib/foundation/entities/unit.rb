require 'grape-entity'

module Foundation
  module Entities
    class Unit < Grape::Entity
      expose :id
      expose :name
    end
  end
end
