FROM crystallang/crystal:0.21.1

# Deps
ENV NPM_CONFIG_LOGLEVEL warn
ENV EXLUDE_DOCKER true
RUN apt-get update
RUN apt-get install curl -y
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install nodejs -y
ADD . /build
WORKDIR /build

# Build
RUN npm install
RUN shards build --release
RUN mv ./bin/psykube /usr/local/bin/psykube

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
RUN psykube init
RUN git add -A
RUN git commit -m "initial commit"

ENTRYPOINT [ "/usr/local/bin/psykube" ]
