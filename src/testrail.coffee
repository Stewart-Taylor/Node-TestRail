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

    closeCommand: (command, id, callback) ->
        request.post(
            uri: this.getFullHostName() + command + id
            headers:
                "content-type": "application/json"
            , (err, res, body) ->
                callback(body) 
        ).auth( @user, @password, true)   


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

    getExtraCommand: (command, id, extra, callback) ->
        request.get(
            uri: this.getFullHostName() + command + id + extra
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
        this.getIdCommand("get_case/" , case_id, callback)


    #getCases: (case_id, callback) ->

    #addCase: (case_id, callback) ->

    #update_case: () ->

    #delete_cate:() ->
       

    #-------- CASE FIELDS -----------------

    getCaseFields: ( callback) ->
        this.getCommand("get_case_fields/" , callback)


    #-------- CASE TYPES ------------------

    getCaseTypes: ( callback) ->
        this.getCommand("get_case_types/" , callback)



    #-------- CONFIGURATIONS ------------------

    getConfigs: (project_id, callback) ->
        this.getIdCommand("get_configs/" , project_id, callback)

    #-------- MILESTONES ------------------

    getMilestone: (milestone_id, callback) ->
        this.getIdCommand("get_milestone/" , milestone_id, callback)

    getMilestones: (project_id, callback) ->
        this.getIdCommand("get_milestones/",project_id, callback)

    #addMilestone: () ->




    #-------- PLANS -----------------------

    getPlan: (plan_id, callback) ->
         this.getIdCommand("get_plan/",plan_id, callback)

    getPlans: (project_id, callback) ->
        this.getIdCommand("get_plans/",project_id, callback)

    #addPlan: () ->

    #addPlanEntries: () ->

    #closePlan: () ->

    #-------- PRIORITIES ------------------

    getPriorities: (callback) ->
        this.getCommand("get_priorities/", callback)



    #-------- PROJECTS --------------------

    getProject: (project_id, callback) ->
        this.getIdCommand("get_project/",project_id, callback)

    getProjects: (callback) ->
        this.getCommand("get_projects/", callback)


    #-------- RESULTS ---------------------

    getResults: (test_id, callback, limit) ->
        if not limit?
            this.getIdCommand("get_results/",test_id, callback)
        else
            extra = "&limit=" + limit
            this.getExtraCommand("get_results/",test_id, extra, callback)

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

    getRun: (run_id, callback) ->
        this.getIdCommand("get_run/" , run_id, callback)

    getRuns: (run_id, callback) ->
        this.getIdCommand("get_runs/" , run_id, callback)



    #TODO: Include all switch and case id select
    addRun: (projectID,suite_id,name,description) ->
        json = {}
        json.suite_id = suite_id
        json.name = name
        json.description = description

        this.sendCommand(projectID, COMMAND_ADD_RUN,json)


    closeRun: (run_id,callback) ->
        this.closeCommand("close_run/", run_id, callback)


    #-------- STATUSES --------------------

    getStatuses: (callback) ->
        this.getCommand("get_statuses/", callback)


     #-------- SECTIONS --------------------

    getSection: (section_id , callback) ->
        this.getIdCommand("get_section/" , section_id, callback)

    #getSections: () ->
     #   this.getIdCommand("get_sections/" , project_id, callback)

    #addSection: () ->


    #updateSection: () ->

    #deleteSection: () ->


    #-------- SUITES -----------

    getSuite: (suite_id, callback) ->
        this.getIdCommand("get_suite/" , suite_id, callback)

    getSuites: (project_id, callback) ->
        this.getIdCommand("get_suites/" , project_id, callback)


    #addSuite: () ->

    #addSection: () ->


    #-------- TESTS -----------------------

    getTest: (test_id, callback) ->
        this.getIdCommand("get_test/" , test_id, callback)


    getTests: (run_id, callback) ->
        this.getIdCommand("get_tests/" , run_id, callback)

    #-------- USERS -----------------------

    getUser: (user_id, callback) ->
        this.getIdCommand("get_user/" , user_id, callback)

    #getUserByEmail: () ->

    #getUsers: () ->

module.exports = TestRail
