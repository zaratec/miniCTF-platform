renderTeamInformation = _.template($("#team-info-template").remove().text())
renderGroupInformation = _.template($("#group-info-template").remove().text())
renderAchievementInformation = _.template($("#achievement-info-template").remove().text())

load_group_info = ->
  apiCall "GET", "/api/group/list"
  .done (data) ->
    switch data["status"]
      when 0
        apiNotify(data)
        ga('send', 'event', 'Team', 'GroupLoadFailure', data.message)
      when 1
        $("#group-info").html renderGroupInformation({data: data.data})

        $("#join-group").on "click", group_request
        $("#group-request-form").on "submit", join_group_request
        $(".leave-group-span").on "click", (e) ->
          leave_group $(e.target).data("group-name"), $(e.target).data("group-owner")

load_achievement_info = ->
    apiCall "GET", "/api/achievements"
    .done (data) ->
      switch data['status']
        when 0
            apiNotify(data)
            ga('send', 'event', 'Achievements', 'LoadFailure', data.message);
        when 1
            $("#achievement-info").html renderAchievementInformation({data: data.data})

join_group = (group_name, group_owner) ->
  apiCall "POST", "/api/group/join", {"group-name": group_name, "group-owner": group_owner}
  .done (data) ->
    apiNotify(data)
    if data["status"] is 1
      ga('send', 'event', 'Team', 'JoinGroup', 'Success')
      load_group_info()
    else
      ga('send', 'event', 'Team', 'JoinGroup', 'Failure::' + data.message)

leave_group = (group_name, group_owner) ->
  apiCall "POST", "/api/group/leave", {"group-name": group_name, "group-owner": group_owner}
  .done (data) ->
    apiNotify(data)
    if data["status"] is 1
      ga('send', 'event', 'Team', 'LeaveGroup', 'Success')
      load_group_info()
    else
      ga('send', 'event', 'Team', 'LeaveGroup', 'Failure::' + data.message)

group_request = (e) ->
  e.preventDefault()
  form = $(this).closest "form"
  confirmDialog("By joining a class you are allowing the instructor to see individual statistics concerning your team's performance. Are you sure you want to join this class?",
                "Class Confirmation", "Join", "Cancel",
        (e) ->
            form.trigger "submit"
       ,(e) ->
            ga('send', 'event', 'Team', 'JoinGroup', 'RejectPrompt'))

join_group_request = (e) ->
  e.preventDefault()

  group_name = $("#group-name-input").val()
  group_owner = $("#group-owner-input").val()
  join_group group_name, group_owner

update = React.addons.update
Panel = ReactBootstrap.Panel
ProgressBar = ReactBootstrap.ProgressBar
Glyphicon = ReactBootstrap.Glyphicon
Row = ReactBootstrap.Row
Col = ReactBootstrap.Col

ProblemInfo = React.createClass
  getInitialState: ->
    solvedProblems: []
    problems: []
    team: {}
    user: {}

  componentWillMount: ->
    apiCall "GET", "/api/team"
    .done ((api) ->
      @setState update @state,
        team: $set: api.data
    ).bind this

    apiCall "GET", "/api/problems"
    .done ((api) ->
      @setState update @state,
        problems: $set: api.data
    ).bind this

    apiCall "GET", "/api/problems/solved"
    .done ((api) ->
      @setState update @state,
        solvedProblems: $set: api.data
    ).bind this

    apiCall "GET", "/api/user/status"
    .done ((api) ->
      @setState update @state,
        user: $set: api.data
    ).bind this

  render: ->
    allProblemsByCategory = _.groupBy @state.problems, "category"
    solvedProblemsByCategory = _.groupBy @state.solvedProblems, "category"

    categories = _.keys allProblemsByCategory

    styles = ["success", "info", "primary", "warning", "danger"]

    glyphs =
      "Cryptography": "/img/lock.svg"
      "Web Exploitation": "/img/browser.svg"
      "Binary Exploitation": "/img/binary.svg"
      "Reverse Engineering": "/img/reversecog.svg"
      "Forensics": "/img/search.svg"
      "Tutorial": "/img/laptop.svg"

    if @state.team and @state.user.username != @state.team.team_name and @state.team.team_name.length > 0
      panelHeader =
      <div>
        Progress Overview <span className="pull-right">Team: <b>{@state.team.team_name}</b></span>
      </div>
    else
      panelHeader =
      <div>Progress Overview</div>

    <Panel key={categories} header={panelHeader}>
      {categories.map (category, i) ->
        currentlySolved = if solvedProblemsByCategory[category] then solvedProblemsByCategory[category].length else 0
        <Row key={i}>
          <Col xs={8} sm={8} md={6} lg={8} className="progress-container">
            <ProgressBar
              now={currentlySolved} bsStyle={styles[i % styles.length]}
              max={allProblemsByCategory[category].length}
              label="%(now)s / %(max)s"/>
          </Col>
          <Col xs={4} sm={4} md={6} lg={4} className="progress-label">
            <img className="category-icon" src={if glyphs[category] then glyphs[category] else "/img/laptop.svg"}/>
            <div className="pull-right">{category}</div>
          </Col>
        </Row>}
    </Panel>

$ ->
  #load_team_info()
  React.render <ProblemInfo/>, document.getElementById("progress-info")
  load_group_info()
  load_achievement_info()
  window.drawTeamProgressionGraph("#team-progression-graph", "#team-progression-graph-container")
