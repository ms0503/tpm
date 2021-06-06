#!/bin/bash
cd $(dirname $0)
browserify tpm-core.js -o tpm-core-standalone.js
printf <<EOS > ./bin/tpm
#!/bin/sh
if [ -z "$(which node)" ]; then
    printf "Error: Node.js is not found.\n"
    exit 1
fi
cd $(dirname $0)
node ./tpm-core-standalone.js
exit $?

EOS
