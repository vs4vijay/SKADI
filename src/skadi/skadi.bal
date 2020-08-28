import ballerina/http;
import ballerina/grpc;
import ballerina/log;
// import ipservice_pb;

listener http:Listener httpListener = new http:Listener(9090);


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
        var ip = getIP();

        http:Response response = new;

        response.statusCode = 200;
        response.setPayload({ip: <@untainted>ip});

        check caller->respond(response);
    }

}

int total = 0;

public function main() {
    log:printInfo("Starting skadi server");

    @strand { thread: "any" }
    worker w1 {
        log:printInfo("[worker:ip]: running worker ip");

        _ = getIP();
    }

    IPServiceClient ipServiceClient = new("http://localhost:9091");

    grpc:Error? result = ipServiceClient->ip("hii", IPServiceListener);
    if (result is grpc:Error) {
        log:printError("Error from Connector: " + result.reason() + " - " + <string>result.detail()["message"]);
    } else {
        log:printInfo("Connected successfully");
    }

    while (total == 0) {}
    log:printInfo("Client got response successfully.");
}

public function getIP() returns @tainted string {
    http:Client ipClient = new("https://wtfismyip.com");
    var resp = ipClient->get("/json");

    string ip = "";

    if(resp is http:Response) {
        var payload = resp.getJsonPayload();

        log:printInfo("Getting IP:");
        log:printInfo(<string>payload);

        if(payload is json) {
            ip = <string>payload.YourFuckingIPAddress;
        }

    }

    return ip;
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

