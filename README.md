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

testrail.getUserByEmail(EMAIL, function(user) {
    console.log(user);
});

testrail.getTest(TEST_ID, function(test) {
    console.log(test);
});
```

All the helper functions can be found under src within testrail.coffee



Available Commands
----

#####CASES


	getCase(case_id, callback)

	getCases(project_id, suite_id, section_id, callback)

	addCase(section_id, title, type_id, project_id, estimate, milestone_id, refs, callback)

	updateCase(case_id, title, type_id, project_id, estimate, milestone_id,refs, callback)

	deleteCase(case_id, callback)

#####Case FIELDS
	getCaseFields(callback)

#####Case TYPES
	getCaseTypes(callback)

#####Configurations
	getConfigs(project_id, callback)

#####Milestones
	getMilestone(milestone_id, callback)

	getMilestones(project_id, callback)

	addMilestone(project_id, name, description, due_on, callback)

	updateMilestone(milestone_id, name, description, due_on, is_completed, callback)

	deleteMilestone(milestone_id, callback)

#####PLANS
	getPlan(plan_id, callback)

	getPlans(project_id, callback)

	addPlan(project_id, name, description, milestone_id, callback)

	addPlanEntry(plan_id, suite_id, name, assignedto_id, include_all, callback)

	updatePlan(plan_id, name, description, milestone_id,callback)

	updatePlanEntry(plan_id, entry_id, name, assignedto_id, include_all, callback)

	closePlan(plan_id, callback)

	deletePlan(plan_id, callback)

	deletePlanEntry(plan_id, entry_id, callback)


#####PRIORITIES
	getPriorities(callback)

#####PROJECTS
	getProject(project_id, callback)

	getProjects(callback)

	addProject(name,announcement,show_announcement, callback)

	updateProject(project_id, name, announcement, show_announcement, is_completed, callback)

	deleteProject(project_id, callback)

#####RESULTS
	getResults(test_id, callback, limit)

	getResultsForCase(run_id, case_id, limit, callback)

	addResult(test_id, status_id, comment, version, elapsed, defects,assignedto_id, callback)

	addResults(run_id, results, callback)

	addResultForCase(run_id, case_id, status_id, comment, version, elapsed,defects, assignedto_id, callback)

	addResultsForCases(run_id, results, callback)

#####RESULT FIELDS
	getResultFields(callback)

#####RUNS
	getRun(run_id, callback)

	getRuns(run_id, callback)

	addRun(projectID,suite_id,name,description, milestone_id, callback)

	updateRun(runID,name,description, callback)

	closeRun(run_id,callback)

	deleteRun(run_id,callback)

#####STATUSES
	getStatuses(callback)

#####SECTIONS
	getSection(section_id, callback)

	getSections(project_id, suite_id, callback)

	addSection(project_id, suite_id, parent_id, name,  callback)

	updateSection(section_id, name, callback)

	deleteSection(section_id, callback)


#####SUITES
	getSuite(suite_id, callback)

	getSuites(project_id, callback)

	addSuite(project_id,name, description, callback)

	updateSuite(suite_id,name, description, callback)

	deleteSuite(suite_id, callback)

#####TESTS
	getTest(test_id, callback)

	getTests(run_id, callback)

#####USERS
	getUser(user_id, callback)

	getUserByEmail(email, callback)



Thank you for using this module and feel free to contribute.

License
----

MIT
