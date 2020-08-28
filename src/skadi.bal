import ballerina/http;
import ballerina/io;


listener http:Listener httpListener = new http:Listener(9090);

service skadi on httpListener {

    resource function healthz(http:Caller caller, http:Request request) returns error? {
        check caller -> respond("health check");
    }

    resource function ip(http:Caller caller, http:Request request) returns error? {
        var ip = getIP();

        http:Response response = new;

        response.statusCode = 200;
        response.setPayload({ip: <@untainted>ip});

        check caller -> respond(response);
    }

}

public function main() {
    io:println("Starting skadi server");

    @strand { thread: "any" }
    worker w1 {
        io:println("[worker:ip]: running worker ip");

        _ = getIP();
    }
}

public function getIP() returns @tainted string {
    http:Client ipClient = new("https://wtfismyip.com");
    var resp = ipClient->get("/json");

    string ip = "";

    if(resp is http:Response) {
        var payload = resp.getJsonPayload();

        io:println("Getting IP:");
        io:println(payload);

        if(payload is json) {
            ip = <string>payload.YourFuckingIPAddress;
        }

    }

    return ip;
}
