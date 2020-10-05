PROJECT :="SKADI"

run:
	ballerina build skadi
	ballerina run target/bin/skadi.jar --b7a.http.accesslog.console=true


run-ip:
	ballerina build ipservice
	ballerina run target/bin/ipservice.jar