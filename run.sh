#!/bin/bash
export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"

##### Preparing data
./prepare_data.pl *-gold.txt

##### template
#train
crf_learn -f 1 -c 10 template training.txt model_4tag_template > log_4tag_template

#test
crf_test -n 1 -m model_4tag_template test.txt > test_4tag_template.out

#evaluate
./convert_to_text.pl training.txt > training
./convert_to_text.pl test.txt > truth

./getDict.pl training > dict

./convert_to_text.pl test_4tag_template.out > test
./score dict truth test

##### template2
#train
crf_learn -f 1 -c 10 template2 training.txt model_4tag_template2 > log_4tag_template2

#test
crf_test -n 1 -m model_4tag_template2 test.txt > test_4tag_template2.out

#evaluate
./convert_to_text.pl test_4tag_template2.out > test
./score dict truth test

##### template3
#train
crf_learn -f 1 -c 10 template3 training.txt model_4tag_template3 > log_4tag_template3

#test
crf_test -n 1 -m model_4tag_template3 test.txt > test_4tag_template3.out

#evaluate
./convert_to_text.pl test_4tag_template3.out > test
./score dict truth test
