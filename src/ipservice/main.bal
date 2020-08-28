import ballerina/grpc;
import ballerina/log;
import skadi/core;


public function main() {
    log:printInfo("IP Service");
}

listener grpc:Listener grpcListener = new grpc:Listener(9091);

service IPService on grpcListener {

    resource function ip(grpc:Caller caller, string name) {
        log:printInfo("Received request from " + name);

        var ip = core:getIP();

        grpc:Headers resHeader = new;
        grpc:Error? err = caller->send(ip, resHeader);
        if (err is grpc:Error) {
            log:printError("Error send sending: " + err.reason() + " - " + <string>err.detail()["message"]);
        }

        grpc:Error? result = caller->complete();
        if (result is grpc:Error) {
            log:printError("Error in sending completed notification to caller", err = result);
        }

    }
}