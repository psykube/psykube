set -e

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

run(){
  echo "$@"
  ($@)& pid=$!
  (sleep 10 && (kill -9 $pid &> /dev/null)) & waiter=$!
  wait $pid &> /dev/null
  finished=$?
  kill $waiter &> /dev/null || true
  if [ -z "$finished" ] ; then echo "Failed \`$@\`" && exit 1 ; fi
}

echo "testing"

run ../bin/psykube init --overwrite --name=psykube-test
run ../bin/psykube generate default
run ../bin/psykube apply default
run ../bin/psykube status default
run ../bin/psykube push
run ../bin/psykube exec default -- echo "hello world"
# run ../bin/psykube port-forward default 8080:80
# run ../bin/psykube logs default & kill $!
run ../bin/psykube copy-namespace apps apps-psykube-test

# Cleanup
run ../bin/psykube delete default
$KUBECTL_BIN delete namespace apps-psykube-test
