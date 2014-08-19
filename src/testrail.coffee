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


    getCommand: (command , callback) ->
        request.get(
            uri: this.getFullHostName() + command 
            headers:
                "content-type": "application/json"
            , (err, res, body) ->
                callback(body) 
        ).auth( @user, @password, true)





    sendCommand: (projectID, command, json) ->
        request.post(
            uri: @host + "/index.php?/api/v2/" + command + projectID
            headers:
                "content-type": "application/json"
            body: JSON.stringify(json)
            , (err, res, body) ->
                return res.body
        ).auth @user, @password, true




    constructPostData: (status_id, comment, test_id, seconds) ->
        post_data = {}
        post_data.status_id = status_id
        post_data.comment = comment
        post_data.elapsed = (seconds + "s")
        JSON.stringify post_data



    #-------- CASES  ----------------------

    getCase: (case_id, callback) ->
        this.getIdCommand("get_case/" , test_id, callback)


    #getCases: (case_id, callback) ->

    #addCase: (case_id, callback) ->

    #update_case: () ->

    #delete_cate:() ->
       


    #-------- CASE TYPES ------------------

    #getCaseTypes: () ->



    #-------- MILESTONES ------------------

    getMilestone: (milestone_id) ->
        this.getIdCommand("get_milestone/" , milestone_id, callback)

    getMilestones: (milestone_id) ->
        this.getIdCommand("get_milestones/", callback)

    #addMilestone: () ->




    #-------- PLANS -----------------------

    #getPlan: () ->

    #getPlans: () ->

    #addPlan: () ->

    #addPlanEntries: () ->

    #closePlan: () ->

    #-------- PRIORITIES ------------------

    #getPriorities: () ->



    #-------- PROJECTS --------------------

    #getProject: () ->

    #getProjects: () ->


    #-------- RESULTS ---------------------

    #getResults: () ->

    #getResultsForCase: () ->

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


    #addResultForCase: () ->


    #-------- RUNS ------------------------

    #getRun: () ->

    getRuns: (run_id, callback) ->
        this.getIdCommand("get_runs/" , run_id, callback)



    #TODO: Include all switch and case id select
    addRun: (projectID,suite_id,name,description) ->
        json = {}
        json.suite_id = suite_id
        json.name = name
        json.description = description

        this.sendCommand(projectID, COMMAND_ADD_RUN,json)


    closeRun: (run_id) ->
        request.post(
            uri: @host + "/index.php?/api/v2/" + "close_run/" + run_id
            headers:
                "content-type": "application/json"
            body: JSON.stringify("")
            , (err, res, body) ->
                return res.body
        ).auth @user, @password, true

    #-------- STATUSES --------------------

    getStatuses: () ->
        this.getIdCommand("get_statuses/", callback)

    #-------- SUITES & SECTIONS -----------

    #getSuite: () ->


    #getSuites: () ->

    #getSections: () ->

    #addSuite: () ->

    #addSection: () ->


    #-------- TESTS -----------------------

    getTest: (test_id, callback) ->
        this.getIdCommand("get_test/" , test_id, callback)


    #getTests: () ->


    #-------- USERS -----------------------

    #getUser: () ->

    #getUserByEmail: () ->

    #getUsers: () ->

module.exports = TestRail
