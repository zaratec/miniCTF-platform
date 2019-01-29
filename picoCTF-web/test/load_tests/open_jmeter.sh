#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
jmeter -JCookieManager.save.cookies=true -t $DIR/load_testing.jmx
