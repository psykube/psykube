FROM crystallang/crystal:0.21.0

# Deps
RUN apt-get update
RUN apt-get install curl -y
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install nodejs -y
ADD . /build
WORKDIR /build
ENV NPM_CONFIG_LOGLEVEL warn

# Build
RUN shards build --release
RUN mv ./bin/psykube /usr/local/bin/psykube

# Move back to root
RUN mkdir /tmp/psykube
WORKDIR /tmp/psykube
RUN git init
RUN psykube init
RUN git config --global user.email "engineering@commercialtribe.com"
RUN git config --global user.name "CommercialTribe, Inc."
RUN git add -A
RUN git commit -m "initial commit"

# Cleanup
RUN apt-get remove nodejs -y
RUN apt-get purge
RUN rm -rf /build
RUN rm `which crystal`
RUN rm `which shards`

ENTRYPOINT [ "/usr/local/bin/psykube" ]
