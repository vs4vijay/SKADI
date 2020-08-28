PROJECT :="SKADI"

run:
	ballerina build skadi
	ballerina run target/bin/skadi.jar


run-ip:
	ballerina build ipservice
	ballerina run target/bin/ipservice.jar