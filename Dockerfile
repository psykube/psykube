FROM crystallang/crystal:0.22.0

# Deps
ARG NPM_CONFIG_LOGLEVEL=warn
ARG EXLUDE_DOCKER=true
RUN apt-get update
RUN apt-get install curl -y
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install nodejs -y
ADD . /build
WORKDIR /build

# Build
RUN npm install
RUN shards build --release psykube-playground
RUN mv ./bin/psykube-playground /usr/local/bin/psykube-playground

# Cleanup
RUN apt-get remove nodejs -y
RUN apt-get purge
RUN rm -rf /build
RUN rm `which crystal`
RUN rm `which shards`

# Move back to root
RUN mkdir /workdir
WORKDIR /workdir
RUN git init
RUN git config --global user.email "engineering@commercialtribe.com"
RUN git config --global user.name "CommercialTribe, Inc."
RUN touch test.text
RUN git add -A
RUN git commit -m "initial commit"

ENV BIND 0.0.0.0

ENTRYPOINT [ "/usr/local/bin/psykube-playground" ]
