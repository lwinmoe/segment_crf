#!/bin/bash

./convert_to_text.pl test.txt > test.gold
sed 's/  //g' test.gold > test.input
