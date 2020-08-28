import ballerina/http;
import ballerina/grpc;
import ballerina/log;

listener http:Listener httpListener = new http:Listener(9090);

IPServiceBlockingClient ipServiceClient = new("http://localhost:9091");


@http:ServiceConfig {
    basePath: "/skadi/v1"
}
service skadi on httpListener {

    @http:ResourceConfig {
        path: "/"
    }
    resource function index(http:Caller caller, http:Request request) returns error? {
        check caller->respond("SKADI Service");
    }

    resource function healthz(http:Caller caller, http:Request request) returns error? {
        check caller->respond("health check");
    }

    resource function ip(http:Caller caller, http:Request request) returns error? {
        var ip = getIP("http");

        http:Response response = new;

        response.statusCode = 200;
        response.setPayload({ip: <@untainted>ip});

        check caller->respond(response);
    }

}

int total = 0;

public function main() {
    log:printInfo("Starting skadi server");

    // GRPC Call with non-blocking, will be used in worker
    IPServiceClient ipServiceClient = new("http://localhost:9091");

    @strand { thread: "any" }
    worker w1 {
        log:printInfo("[worker:ip]: running worker ip");

        grpc:Error? result = ipServiceClient->ip("boot", IPServiceListener);
        if (result is grpc:Error) {
            log:printError("Error from Connector: " + result.reason() + " - " + <string>result.detail()["message"]);
        } else {
            log:printInfo("Connected successfully");
        }
    }

}

service IPServiceListener = service {

    resource function onMessage(string message) {
        log:printInfo("Response received from server: " + message);
    }

    resource function onError(error err) {
        log:printError("Error reported from server: " + err.reason() + " - " + <string>err.detail()["message"]);
    }

    resource function onComplete() {
        log:printInfo("Server Complete Sending Response.");
        total = 1;
    }
};

public function getIP(string message) returns string {
    string ip = "";
    
    var response = ipServiceClient->ip(message);
    if (response is grpc:Error) {
        log:printError("Error from Connector: " + response.reason() + " - " + <string>response.detail()["message"]);
    } else {
        var [result, _] = response;
        log:printInfo("Got Response: " + result);
        ip = result;
    }

    return ip;
}