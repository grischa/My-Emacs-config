#!/bin/bash
java -jar ~/.emacs.d/compiler-latest.jar --warning_level VERBOSE --js $1 --js_output_file /dev/null
# get this at http://code.google.com/closure/compiler/ and http://closure-compiler.googlecode.com/files/compiler-latest.zip