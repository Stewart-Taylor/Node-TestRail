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

    addCommand: (command, id, postData, callback) ->
        request.post(
            uri: this.getFullHostName() + command + id
            headers:
                "content-type": "application/json"
            body: postData
            , (err, res, body) ->
                callback(body)
        ).auth( @user, @password, true)


    addExtraCommand: (command, id, extra, postData, callback) ->
        request.post(
            uri: this.getFullHostName() + command + id + extra,
            headers:
                "content-type": "application/json"
            body: postData
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


    getCases: (project_id, suite_id, section_id, callback) ->
        if section_id?
            this.getExtraCommand("get_cases/", project_id, "&suite_id=" + suite_id + "&section_id=" + section_id, callback) 
        else
            this.getExtraCommand("get_cases/", project_id, "&suite_id=" + suite_id , callback)  

    addCase: (section_id, title, type_id,project_id,estimate,milestone_id,refs, callback) ->
        json = {}
        json.title = title
        json.type_id = type_id
        json.project_id = project_id
        json.estimate = estimate
        json.milestone_id = milestone_id
        json.refs = refs
        this.addCommand("add_case/", section_id, JSON.stringify(json) , callback)

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

    addMilestone: (project_id, name, description, due_on, callback) ->
        json = {}
        json.name = name
        json.description = description
        json.due_on = due_on
        this.addCommand("add_milestone/", project_id, JSON.stringify(json), callback)

    #-------- PLANS -----------------------

    getPlan: (plan_id, callback) ->
        this.getIdCommand("get_plan/",plan_id, callback)

    getPlans: (project_id, callback) ->
        this.getIdCommand("get_plans/",project_id, callback)

    addPlan: (project_id, name, description, milestone_id,callback) ->
        json = {}
        json.name = name
        json.description = description
        json.milestone_id = milestone_id
        this.addCommand("add_plan/", project_id, JSON.stringify(json), callback)

    #TODO: update to handle extra params
    addPlanEntry: (plan_id, suite_id, name, assignedto_id,include_all, callback) ->
        json = {}
        json.suite_id = suite_id
        json.name = name
        json.assignedto_id = assignedto_id
        json.include_all = include_all
        this.addCommand("add_plan_entry/", plan_id, JSON.stringify(json), callback)

    #closePlan: () ->

    #-------- PRIORITIES ------------------

    getPriorities: (callback) ->
        this.getCommand("get_priorities/", callback)



    #-------- PROJECTS --------------------

    getProject: (project_id, callback) ->
        this.getIdCommand("get_project/",project_id, callback)

    getProjects: (callback) ->
        this.getCommand("get_projects/", callback)

    addProject: (name,announcement,show_announcement, callback) ->
        json = {}
        json.name = name
        json.announcement = announcement
        json.show_announcement = show_announcement
        this.addCommand("add_project/", "", JSON.stringify(json), callback)


    #updateProject: () ->

    deleteProject: (project_id, callback) ->
        this.closeCommand("delete_project/",project_id, callback)

    #-------- RESULTS ---------------------

    getResults: (test_id, callback, limit) ->
        if not limit?
            this.getIdCommand("get_results/",test_id, callback)
        else
            extra = "&limit=" + limit
            this.getExtraCommand("get_results/",test_id, extra, callback)

    #getResultsForCase: () ->


    #TODO: Use new command functions
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


    addResultForCase: (run_id,case_id,status_id,comment,version,elapsed,defects,assignedto_id, callback) ->
        json = {}
        json.status_id = status_id
        json.comment = comment
        json.version = version
        json.elapsed = elapsed
        json.defects = defects
        json.assignedto_id = assignedto_id
        this.addExtraCommand("add_result_for_case/", run_id, ("/" + case_id),  JSON.stringify(json), callback)

    #addResultsForCases

    #-------- RESULT FIELDS ---------------------
    getResultFields: (callback) ->
        this.getIdCommand("get_result_fields/" , "", callback)

    #-------- RUNS ------------------------

    getRun: (run_id, callback) ->
        this.getIdCommand("get_run/" , run_id, callback)

    getRuns: (run_id, callback) ->
        this.getIdCommand("get_runs/" , run_id, callback)



    #TODO: Include all switch and case id select
    addRun: (projectID,suite_id,name,description, callback) ->
        json = {}
        json.suite_id = suite_id
        json.name = name
        json.description = description
        this.addCommand("add_run/", projectID, JSON.stringify(json) , callback)


    closeRun: (run_id,callback) ->
        this.closeCommand("close_run/", run_id, callback)


    #-------- STATUSES --------------------

    getStatuses: (callback) ->
        this.getCommand("get_statuses/", callback)


     #-------- SECTIONS --------------------

    getSection: (section_id , callback) ->
        this.getIdCommand("get_section/" , section_id, callback)

    getSections: (project_id, suite_id, callback) ->
        this.getExtraCommand("get_sections/" , project_id, "&suite_id=" + suite_id, callback)

    #addSection: () ->


    #updateSection: () ->

    #deleteSection: () ->


    #-------- SUITES -----------

    getSuite: (suite_id, callback) ->
        this.getIdCommand("get_suite/" , suite_id, callback)

    getSuites: (project_id, callback) ->
        this.getIdCommand("get_suites/" , project_id, callback)


    addSuite: (project_id,name, description, callback) ->
        json = {}
        json.name = name
        json.description = description
        this.addCommand("add_suite/", project_id, JSON.stringify(json) , callback)
        

    #addSection: () ->


    #-------- TESTS -----------------------

    getTest: (test_id, callback) ->
        this.getIdCommand("get_test/" , test_id, callback)


    getTests: (run_id, callback) ->
        this.getIdCommand("get_tests/" , run_id, callback)

    #-------- USERS -----------------------

    getUser: (user_id, callback) ->
        this.getIdCommand("get_user/" , user_id, callback)

    getUserByEmail: (email, callback) ->
        this.getExtraCommand("" , "", "get_user_by_email&email=" + email, callback)

    #getUsers: () ->

module.exports = TestRail
