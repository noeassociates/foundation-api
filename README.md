# Foundation::API

`Foundation::API` is the interface for external clients to express interest in "available units". It's meant to be a reusable interface for residential development websites.

# Installation

```ruby
gem 'foundation-api', git: 'git@github.com:noeassociates/foundation-api.git'
```

# Development Server

The `foundation-api` repository includes a development Rack application that can be used for testing API clients. From inside the repository, run `bundle` to install the dependencies, and then `bundle exec rackup` to start the development server at `http://localhost:9292`.

# Usage

If using Rails, the `Foundation::API` endpoints can be mounted in your routes:

```ruby
Rails.application.routes.draw do
  mount Foundation::API => '/'
  mount Foundation::Documentation => '/'
end
```

If your application is Rack-based, mount the endpoints as you would a normal Rack application.

Visit `/api/docs` in your application to view the endpoints exposed by `Foundation::API`.

# Configuration

There are two configuration options available. These can be set up in an initializer if you're using Rails, otherwise configuration should be set once in your boot process.

```ruby
Foundation.config do |f|
  f.unit_class = Unit
  f.builders << MyUnitBuilder
end
```

The `unit_class` option defaults to a null class that will return empty data sets. `unit_class` must be set to the class that represents Units in the database of you application. `Foundation::API` expects that this class responds to the `name` and `id` methods.

The `builders` option is an array of classes that will receive the parameters passed to the interest endpoint. Builder classes must inherit from the base `Foundation::Builder`, and must implement a `build` method. A sample builder might look like this:

```ruby
class UnitBuilder < Foundation::Builder

  def build(params)
    Unit.create params
  end

end
```

The attribute `request` is also available inside of a Builder class, if additional data about the request should be recorded.

```ruby
class IPLoggerBuilder < Foundation::Builder

  def build(*)
    Rails.logger.warn("#{request.ip} posted a request")
  end

end
```

If you need to return some value to the request, the `build` method can accept an additional argument that represents the response hash (actually a `Hashie::Mash`):

```ruby
class TalkativeBuilder < Foundation::Builder

  def build(params, response)
    response.greeting = 'Hi!'
  end

end
```

Multiple Builders can be configured and the params hash will be passed to each in the order they are added.

```ruby
Foundation.config do |f|
  f.builders << UnitBuilder
  f.builders << IPLoggerBuilder
end
```
