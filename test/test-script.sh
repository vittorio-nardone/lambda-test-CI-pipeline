#!/bin/sh
curl --data-binary "@/var/task/test/test-event.json" http://localhost:9001/2015-03-31/functions/myfunction/invocations