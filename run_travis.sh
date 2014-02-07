#!/bin/bash

echo "Travis test runner..."
echo "SUITE: ${SUITE}"

if [ "$SUITE" = "rspec" ]
then
	bundle exec rake spec 2>&1
	exit
elif [ "$SUITE" = "cucumber" ]
then
	PHANTOMJS=true NO_WEBDRIVER_MONKEY_PATCH=true bundle exec cucumber -ptravis 2>&1
	exit
elif [ "$SUITE" = "mocha" ]
then
	bundle exec rails server &
	echo "Waiting rails server to start..."
	sleep 10
	grunt mocha 2>&1
	exit
elif [ "$SUITE" = "jshint" ]
then
	grunt jshint 2>&1
	exit
else
	echo -e "Error: SUITE is illegal or not set\n"
	exit 1
fi