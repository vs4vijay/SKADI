# SKADI

## Running

```shell
ballerina run src/skadi/skadi.bal

OR

make run
make run-ip
```

---

## Resources
- https://ballerina.io/learn/by-example/

---

### Development Notes

```

ballerina new skadi
ballerina add skadi
ballerina add ipservice

curl localhost:9090/skadi/v1/healthz


--b7a.http.accesslog.console=true


WebSub

https://ballerina.io/learn/by-example/grpc-unary-blocking.html

ballerina grpc --input src/ipservice.proto --output stubs
ballerina build ipservice
ballerina run target/bin/ipservice.jar 


go get -u github.com/kazegusuri/grpcurl


ballerina init

ballerina swagger mock https://petstore.swagger.io/v2/swagger.json -m petstore-mock

ballerina swagger client https://petstore.swagger.io/v2/swagger.json -m petstore-client

```