Node-TestRail
=========


Node-TestRail is an api wrapper for node. It contains an easy way to interact with all of the API commands for version 2 of the testrail API.

    http://docs.gurock.com/testrail-api2/start

How to use
----
```javascript
var TestRail = require("Node-TestRail");

var testrail = new TestRail("https://example.testrail.com/", "email@example.com", "password");

testrail.getUser(1, 1, "It broke", "1.0", "10s", null, 7, function(body) {
    console.log(body);
});
```



License
----

MIT
