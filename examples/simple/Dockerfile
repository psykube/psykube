FROM ruby
RUN gem install rack
ARG NPM_TOKEN
ENV PORT 8080
ADD server.rb server.rb
CMD ruby server.rb
