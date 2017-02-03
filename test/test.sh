set -e

run(){
  timeout=$1
  shift
  trap "trap - SIGTERM && kill -- -$$ > /dev/null" SIGINT SIGTERM EXIT
  echo "$@"
  ($@)& pid=$!
  (sleep $timeout && (kill -9 $pid &> /dev/null)) & waiter=$!
  wait $pid &> /dev/null
  finished=$?
  kill $waiter &> /dev/null || true
  if [ -z "$finished" ] ; then echo "Failed \`$@\`" && exit 1 ; fi
}

echo "testing"

run 10  ../bin/psykube init --overwrite --name=psykube-test
run 10  ../bin/psykube generate default
run 300 ../bin/psykube apply default
run 10  ../bin/psykube status default
run 10  ../bin/psykube push
run 120 ../bin/psykube exec default -- echo "hello world"
# ../bin/psykube port-forward default 8080:80
# ../bin/psykube logs default & kill $!
run 120 ../bin/psykube copy-namespace apps apps-psykube-test

# Cleanup
run ../bin/psykube delete default
$KUBECTL_BIN delete namespace apps-psykube-test
