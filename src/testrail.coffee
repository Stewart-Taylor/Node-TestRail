request = require("request")

TEST_FAILED = 5
TEST_PASSED = 1

API_ROUTE = "/index.php?/api/v2/"



#Commands
COMMAND_ADD_RUN = "add_run/"

class TestRail

    constructor: (@host, @user, @password) ->
 

    getFullHostName: () ->
        return @host + API_ROUTE


    getIdCommand: (command , id, callback) ->
        request.get(
            uri: this.getFullHostName() + command + id
            headers:
                "content-type": "application/json"
            , (err, res, body) ->
                callback(body) 
        ).auth( @user, @password, true)




    #TODO: Include all switch and case id select
    addTestRun: (projectID,suite_id,name,description) ->
        json = {}
        json.suite_id = suite_id
        json.name = name
        json.description = description

        this.sendCommand(projectID, COMMAND_ADD_RUN,json)


    sendCommand: (projectID, command, json) ->
        request.post(
            uri: @host + "/index.php?/api/v2/" + command + projectID
            headers:
                "content-type": "application/json"
            body: JSON.stringify(json)
            , (err, res, body) ->
                return res.body
        ).auth @user, @password, true


    closeRun: (run_id) ->
        request.post(
            uri: @host + "/index.php?/api/v2/" + "close_run/" + run_id
            headers:
                "content-type": "application/json"
            body: JSON.stringify("")
            , (err, res, body) ->
                return res.body
        ).auth @user, @password, true


    getStatuses: () ->
        request.get(
            uri: @host + "/index.php?/api/v2/" + "get_statuses"
            headers:
                "Content-Type": "application/json"
            , (err, res, body) ->
                return res.body
        ).auth @user, @password, true


    getRuns: (run_id, callback) ->
        this.getIdCommand("get_runs/" , run_id, callback)



    getTest: (test_id) ->
        request.get(
            uri: @host + "/index.php?/api/v2/" + "get_test/" + test_id
            headers:
                "content-type": "application/json"
            , (err, res, body) ->
                return res.body
        ).auth @user, @password, true


    getCase: (case_id) ->
        request.get(
            uri: @host + "/index.php?/api/v2/" + "get_case/" + case_id
            headers:
                "content-type": "application/json"
            , (err, res, body) ->
                return res.body
        ).auth @user, @password, true


    getMilestone: (milestone_id) ->
        request.get(
            uri: @host + "/index.php?/api/v2/" + "get_milestone/" + milestone_id
            headers:
                "content-type": "application/json"
            , (err, res, bodyC) ->
                console.log(bodyC)
                return res.body
        ).auth @user, @password, true

    getMilestones: (milestone_id) ->
        request.get(
            uri: @host + "/index.php?/api/v2/" + "get_milestones/" 
            headers:
                "content-type": "application/json"
            , (err, res, body) ->
                return res.body
        ).auth @user, @password, true


    addResult: (status, comment, test_id, seconds) ->

        #We set to fail by default
        status_id = TEST_FAILED

        #Checks if test Passes
        status_id = TEST_PASSED  if status is true
        postData = testRailHelper.constructPostData(status_id, comment, test_id, seconds)
        testRailHelper.displayTestAdded postData
        request.post(
          uri: settings.host + settings.command + test_id
          headers:
            "content-type": "application/json"

          body: postData
        , (err, res, body) ->
          process.exit 1  if status is false
        ).auth settings.user, settings.password, true

    constructPostData: (status_id, comment, test_id, seconds) ->
        post_data = {}
        post_data.status_id = status_id
        post_data.comment = comment
        post_data.elapsed = (seconds + "s")
        JSON.stringify post_data






module.exports = TestRail
