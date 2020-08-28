import ballerina/http;

listener http:Listener httpListener = new http:Listener(9090);

service skadi on httpListener {

    resource function healthz(http:Caller caller, http:Request request) returns error? {

        check caller -> respond("health check");

    }

}

