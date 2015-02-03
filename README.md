Node-TestRail
=========


!["npm badge"](https://nodei.co/npm/node-testrail.png)

Node-TestRail is an api wrapper for TestRail. It contains an easy way to interact with all of the API commands for version 2 of the testrail API.

    http://docs.gurock.com/testrail-api2/start

How to use (Examples)
----
```javascript
var TestRail = require("node-testrail");

var testrail = new TestRail("https://example.testrail.com/", "email@example.com", "password");

testrail.addResult(TEST_ID, STATUS_ID, COMMENT, VERSION, ELAPSED_TIME, DEFECTS, ASSIGNEDTO_ID, function(body) {
    console.log(body);
});

testrail.getUserByEmail(EMAIL, function(body) {
    console.log(body);
});

testrail.getTest(TEST_ID, function(body) {
    console.log(body);
});
```

All the helper functions can be found under src within testrail.coffee

License
----

MIT
