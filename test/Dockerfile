FROM ruby

ENV PORT 9292
ENV TEXT "hello psykube"

RUN gem install rack

CMD rackup -b "run ->(env){ [200, {}, [ENV['TEXT']]] }" -p $PORT
