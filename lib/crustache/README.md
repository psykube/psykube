# crustache

crustache is the implementation of __[mustache](https://mustache.github.io/)__ logic-less templates.

This library implemated [mustache's spec v1.1.2+λ](https://github.com/mustache/spec/tree/v1.1.2).

[![travis-ci.org](https://img.shields.io/travis/MakeNowJust/crustache.svg?style=flat-square)](https://travis-ci.org/MakeNowJust/crustache)
[![docrystal.org](http://www.docrystal.org/badge.svg)](http://www.docrystal.org/github.com/MakeNowJust/crustache)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  crustache:
      github: MakeNowJust/crustache
```

## Usage

```crystal
require "crustache"

# Parse a mustache template
template = Crustache.parse "Hello {{Name}} World!"

# Make a model
model = {"Name" => "Crustache"}

# Render!
puts Crustache.render template, model
#=> Hello Crustache World!
```

## Development

This library's specs are put in `spec` directory. They can run by `crystal spec ./spec/spec.cr` command.

## Contributing

1. Fork it ([https://github.com/MakeNowJust/crustache/fork](https://github.com/MakeNowJust/crustache/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [@MakeNowJust](https://github.com/MakeNowJust) TSUYUSATO Kitsune - creator, maintainer
