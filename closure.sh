#!/bin/bash
java -jar ~/.emacs.d/compiler.jar --warning_level VERBOSE --js $1 --js_output_file /dev/null
