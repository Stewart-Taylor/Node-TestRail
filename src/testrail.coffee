request = require("request")

API_ROUTE = "/index.php?/api/v2/"


class TestRail

    constructor: (@host, @user, @password) ->

    # used to construct the host name for the API request
    # Internal Command
    #
    getFullHostName: () ->
        return @host + API_ROUTE


    # Used to perform a close command on the API
    # Internal Command
    #
    # @param [command] The command to send to the API
    # @param [id] The id of the object to target in the API
    # @return [callback] The callback
    #
    closeCommand: (command, id, callback) ->
        request.post(
            uri: this.getFullHostName() + command + id
            headers:
                "content-type": "application/json"
            , (err, res, body) ->
                callback(body)
        ).auth( @user, @password, true)


    # Used to get an object in the API by the ID
    # Internal Command
    #
    # @param [command] The command to send to the API
    # @param [id] The id of the object to target in the API
    # @return [callback] The callback
    #
    getIdCommand: (command , id, callback) ->
        request.get(
            uri: this.getFullHostName() + command + id
            headers:
                "content-type": "application/json"
            ,(err, res, body) ->
                callback(body)
        ).auth( @user, @password, true)


    # Used to get an object in the API
    # Internal Command
    #
    # @param [command] The command to send to the API
    # @return [callback] The callback
    #
    getCommand: (command, callback) ->
        request.get(
            uri: this.getFullHostName() + command
            headers:
                "content-type": "application/json"
            ,(err, res, body) ->
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

    # Used to fetch a case from the API
    #
    # @param [case_id] The ID of the case to fetch
    # @return [callback] The callback with the case object
    #
    getCase: (case_id, callback) ->
        this.getIdCommand("get_case/", case_id, callback)


    # Used to fetch a cases from the API
    #
    # @param [project_id] The ID of the project
    # @param [suite_id] The ID of the suite
    # @param [section_id] The ID of the section
    # @return [callback] The callback with the case object
    #
    getCases: (project_id, suite_id, section_id, callback) ->
        if section_id?
            this.getExtraCommand("get_cases/", project_id, "&suite_id=" + suite_id + "&section_id=" + section_id, callback)
        else
            this.getExtraCommand("get_cases/", project_id, "&suite_id=" + suite_id , callback)


    # Used to add cases to the API
    #
    # @param [section_id] The ID of the section where to add
    # @param [title] The title of the case
    # @param [type_id] The id for the type of case
    # @param [project_id] The ID of the project
    # @param [estimate] The estimate of the case
    # @param [milestone_id] The ID of the milestone to add to
    # @param [refs]
    # @return [callback] The callback with the case object
    #
    addCase: (section_id, title, type_id, project_id, estimate, milestone_id, refs, callback) ->
        json = {}
        json.title = title
        json.type_id = type_id
        json.project_id = project_id
        json.estimate = estimate
        json.milestone_id = milestone_id
        json.refs = refs
        this.addCommand("add_case/", section_id, JSON.stringify(json) , callback)

    updateCase: (case_id, title, type_id,project_id,estimate,milestone_id,refs, callback) ->
        json = {}
        json.title = title
        json.type_id = type_id
        json.project_id = project_id
        json.estimate = estimate
        json.milestone_id = milestone_id
        json.refs = refs
        this.addCommand("update_case/", case_id, JSON.stringify(json) , callback)

    deleteCase:(case_id, callback) ->
        this.closeCommand("delete_case/" , case_id, callback)

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

    updateMilestone: (milestone_id, name, description, due_on, is_completed, callback) ->
        json = {}
        json.name = name
        json.description = description
        json.due_on = due_on
        json.is_completed = is_completed
        this.addCommand("update_milestone/", milestone_id, JSON.stringify(json), callback)

    deleteMilestone: (milestone_id, callback) ->
        this.closeCommand("delete_milestone/", milestone_id, callback)

    #-------- PLANS -----------------------

    getPlan: (plan_id, callback) ->
        this.getIdCommand("get_plan/",plan_id, callback)

    getPlans: (project_id, callback) ->
        this.getIdCommand("get_plans/",project_id, callback)

    addPlan: (project_id, name, description, milestone_id, callback) ->
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

    updatePlan: (plan_id, name, description, milestone_id,callback) ->
        json = {}
        json.name = name
        json.description = description
        json.milestone_id = milestone_id
        this.addCommand("update_plan/", plan_id, JSON.stringify(json), callback)

    updatePlanEntry: (plan_id, entry_id, name, assignedto_id,include_all, callback) ->
        json = {}
        json.name = name
        json.assignedto_id = assignedto_id
        json.include_all = include_all
        this.addCommand("update_plan_entry/", (plan_id + "/" + entry_id), JSON.stringify(json), callback)

    closePlan: (plan_id, callback) ->
        this.closeCommand("close_plan/", plan_id, callback)

    deletePlan: (plan_id, callback) ->
        this.closeCommand("delete_plan/", plan_id, callback)

    deletePlanEntry: (plan_id, entry_id, callback) ->
        this.closeCommand("delete_plan_entry/", (plan_id + "/" + entry_id), callback)

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

    updateProject: (project_id, name,announcement,show_announcement, is_completed, callback) ->
        json = {}
        json.name = name
        json.announcement = announcement
        json.show_announcement = show_announcement
        json.is_completed = is_completed
        this.addCommand("add_project/", project_id, JSON.stringify(json), callback)

    deleteProject: (project_id, callback) ->
        this.closeCommand("delete_project/",project_id, callback)

    #-------- RESULTS ---------------------

    getResults: (test_id, callback, limit) ->
        if not limit?
            this.getIdCommand("get_results/",test_id, callback)
        else
            extra = "&limit=" + limit
            this.getExtraCommand("get_results/",test_id, extra, callback)

    getResultsForCase: (run_id, case_id, limit, callback) ->
        if not limit?
            extra = "/" + case_id
            this.getExtraCommand("get_results_for_case/",run_id, extra, callback)
        else
            extra = "/" + case_id + "&limit=" + limit
            this.getExtraCommand("get_results_for_case/",run_id, extra, callback)

    addResult: (test_id, status_id, comment, version, elapsed, defects, assignedto_id, callback) ->
        json = {}
        json.status_id = status_id
        json.comment = comment
        json.version = version
        json.elapsed = elapsed
        json.defects = defects
        json.assignedto_id = assignedto_id
        this.addCommand("add_result/", test_id,  JSON.stringify(json), callback)

     addResults: (run_id, results, callback) ->
        this.addExtraCommand("add_results/", run_id,  JSON.stringify(results), callback)

    addResultForCase: (run_id, case_id, status_id, comment, version, elapsed, defects, assignedto_id, callback) ->
        json = {}
        json.status_id = status_id
        json.comment = comment
        json.version = version
        json.elapsed = elapsed
        json.defects = defects
        json.assignedto_id = assignedto_id
        this.addExtraCommand("add_result_for_case/", run_id, ("/" + case_id),  JSON.stringify(json), callback)

    addResultsForCases: (run_id, results, callback) ->
        this.addExtraCommand("add_results_for_cases/", run_id, "",  JSON.stringify(results), callback)

    #-------- RESULT FIELDS ---------------------

    getResultFields: (callback) ->
        this.getIdCommand("get_result_fields/" , "", callback)

    #-------- RUNS ------------------------

    getRun: (run_id, callback) ->
        this.getIdCommand("get_run/" , run_id, callback)

    getRuns: (run_id, callback) ->
        this.getIdCommand("get_runs/" , run_id, callback)

    #TODO: Include all switch and case id select
    addRun: (projectID,suite_id,name,description, milestone_id, callback) ->
        json = {}
        json.suite_id = suite_id
        json.name = name
        json.description = description
        json.milestone_id = milestone_id
        this.addCommand("add_run/", projectID, JSON.stringify(json) , callback)

    updateRun: (runID,name,description, callback) ->
        json = {}
        json.name = name
        json.description = description
        this.addCommand("update_run/", runID, JSON.stringify(json) , callback)

    closeRun: (run_id,callback) ->
        this.closeCommand("close_run/", run_id, callback)

    deleteRun: (run_id,callback) ->
        this.closeCommand("delete_run/", run_id, callback)

    #-------- STATUSES --------------------

    getStatuses: (callback) ->
        this.getCommand("get_statuses/", callback)

    #-------- SECTIONS --------------------

    getSection: (section_id , callback) ->
        this.getIdCommand("get_section/" , section_id, callback)

    getSections: (project_id, suite_id, callback) ->
        this.getExtraCommand("get_sections/" , project_id, "&suite_id=" + suite_id, callback)

    addSection: (project_id, suite_id, parent_id, name,  callback) ->
        json = {}
        json.suite_id = suite_id
        json.parent_id = parent_id
        json.name = name
        this.addCommand("add_section/", project_id, JSON.stringify(json) , callback)

    updateSection: (section_id, name, callback) ->
        json = {}
        json.name = name
        this.addCommand("update_Section/", section_id, JSON.stringify(json) , callback)

    deleteSection: (section_id, callback) ->
        this.closeCommand("delete_section/", section_id, callback)

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

    updateSuite: (suite_id,name, description, callback) ->
        json = {}
        json.name = name
        json.description = description
        this.addCommand("update_suite/", suite_id, JSON.stringify(json) , callback)

    deleteSuite: (suite_id, callback) ->
        this.closeCommand("delete_suite/", suite_id, callback)

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

    getUsers: (callback) ->
        this.getCommand("get_users/" , callback)

module.exports = TestRail
