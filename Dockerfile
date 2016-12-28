FROM ruby
RUN gem install rack
EXPOSE 8080
ARG NPM_TOKEN
CMD ruby -r rack -e "Rack::Server.start(app: ->(env){ [200, {'Content-Type' => 'text/html'}, ['hello world']] })"
