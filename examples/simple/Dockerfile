FROM crystallang/crystal

# Run and build
ADD server.cr server.cr
RUN crystal build ./server.cr

ENV PORT 8080
# Set env

CMD ./server
