import ballerina/http;
import ballerina/log;

public function getIP() returns @tainted string {
    http:Client ipClient = new("https://wtfismyip.com");
    var resp = ipClient->get("/json");

    string ip = "";

    if(resp is http:Response) {
        var payload = resp.getJsonPayload();

        log:printInfo("Getting IP:");

        if(payload is json) {
            log:printInfo(payload.toString());
            ip = <string>payload.YourFuckingIPAddress;
        } else {
            log:printError("Not able to get IP");
        }

    }

    return ip;
}