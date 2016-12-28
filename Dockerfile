FROM ruby
RUN gem install rack
ARG NPM_TOKEN
ENV PORT 8080
CMD ruby -r rack -e "Rack::Server.start(Port: $PORT, app: ->(env){ [200, {'Content-Type' => 'text/html'}, ['hello world']] })"
