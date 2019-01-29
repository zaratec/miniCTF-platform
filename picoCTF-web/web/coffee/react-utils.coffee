Tooltip = ReactBootstrap.Tooltip
OverlayTrigger = ReactBootstrap.OverlayTrigger
Input = ReactBootstrap.Input
Row = ReactBootstrap.Row
Col = ReactBootstrap.Col
Button = ReactBootstrap.Button
Panel = ReactBootstrap.Panel
ListGroup = ReactBootstrap.ListGroup
ListGroupItem = ReactBootstrap.ListGroupItem
Glyphicon = ReactBootstrap.Glyphicon

update = React.addons.update

Hint = React.createClass
  propTypes:
    text: React.PropTypes.string.isRequired

  render: ->
    tooltip = <Tooltip>{@props.text}</Tooltip>
    <OverlayTrigger placement="top" overlay={tooltip}>
      <Glyphicon className="pad" glyph="question-sign" style={fontSize:"0.8em"}/>
    </OverlayTrigger>

EmailWhitelistItem = React.createClass
  propTypes:
    email: React.PropTypes.string.isRequired
    pushUpdates: React.PropTypes.func.isRequired

  render: ->
    removeEmail = @props.pushUpdates.bind null, ((data) ->
      update data, {email_filter: {$apply: _.partial _.without, _, @props.email}}
    ).bind this

    <ListGroupItem>
      *@{@props.email}
      <span className="pull-right"><Glyphicon glyph="remove" onClick={removeEmail}/></span>
    </ListGroupItem>

EmailWhitelist = React.createClass
  mixins: [React.addons.LinkedStateMixin]

  getInitialState: -> {}

  propTypes:
    pushUpdates: React.PropTypes.func.isRequired
    emails: React.PropTypes.array.isRequired

  addEmailDomain: (e) ->
    # It would probably make more sense to this kind of validation server side.
    # However, it can't cause any real issue being here.

    e.preventDefault()

    if _.indexOf(@props.emails, @state.emailDomain) != -1
      apiNotify {status: 0, message: "This email domain has already been whitelisted."}
    else if _.indexOf(@state.emailDomain, "@") != -1
      apiNotify {status: 0, message: "You should not include '@'. I want the email domain that follows '@'."}
    else if _.indexOf(@state.emailDomain, ".") == -1
        apiNotify {status: 0, message: "Your email domain did not include a '.' as I expected. Please make sure this is an email domain."}
    else
      @props.pushUpdates ((data) ->
        update data, {email_filter: {$push: [@state.emailDomain]}}
      ).bind this

  createItemDisplay: ->
    <ListGroup>
      {@props.emails.map ((email, i) ->
        <EmailWhitelistItem key={i} email={email} pushUpdates={@props.pushUpdates}/>
      ).bind this}
    </ListGroup>

  render: ->
    emptyItemDisplay =
      <p>The whitelist is current empty. All emails will be accepted during registration.</p>

    <div>
      <h4>Email Domain Whitelist</h4>
      <form onSubmit={@addEmailDomain}>
        <Row>
          <Input type="text" addonBefore="@ Domain" valueLink={@linkState "emailDomain"}/>
        </Row>
        <Row>
          {if @props.emails.length > 0 then @createItemDisplay() else emptyItemDisplay}
        </Row>
      </form>
    </div>


FormEntry = React.createClass
  propTypes:
    name: React.PropTypes.string.isRequired
    entry: React.PropTypes.object.isRequired
    description: React.PropTypes.string

  render: ->
    if @props.description
      hint = <Hint text={@props.description} />
    else
      hint = ""

    <Row>
      <Col md={4}>
        <h4 className="pull-left">
          {hint}
          {@props.name}
        </h4>
      </Col>
      <Col md={8}>
        {@props.entry}
      </Col>
    </Row>

TextEntry = React.createClass
  propTypes:
    name: React.PropTypes.string.isRequired
    type: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired

  render: ->
    input = <Input className="form-control" type={@props.type} value={@props.value} onChange={@props.onChange} />
    <FormEntry entry={input} {...@props} />

BooleanEntry = React.createClass
  propTypes:
    name: React.PropTypes.string.isRequired
    value: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func.isRequired

  render: ->
    button = <Button bsSize="xsmall" onClick=@props.onChange>{if @props.value then "Enabled" else "Disabled"}</Button>
    <FormEntry entry={button} {...@props} />

TimeEntry = React.createClass
  propTypes:
    name: React.PropTypes.string.isRequired
    value: React.PropTypes.number.isRequired
    onChange: React.PropTypes.func.isRequired

  componentDidMount: ->
    date = new Date(@props.value)
    node = React.findDOMNode(@refs.datetimepicker)
    $(node).datetimepicker
      defaultDate: date
      inline: true,
      sideBySide: true
    .on "dp.change", ((e) ->
      @props.onChange e.date.toDate().getTime()
    ).bind(this)

  render: ->
    timepicker = <Panel> <div ref="datetimepicker"></div> </Panel>
    <FormEntry entry={timepicker} {...@props} />

OptionEntry = React.createClass
  propTypes:
    name: React.PropTypes.string.isRequired
    value: React.PropTypes.string.isRequired
    options: React.PropTypes.array.isRequired
    onChange: React.PropTypes.func.isRequired

  render: ->
    buttons = _.map @props.options, ((option) ->
      onClick = ((e) ->
        @props.onChange option
      ).bind(this)

      buttonClass = if option == @props.value then "active" else ""
      <Button onClick={onClick} className={buttonClass}>{option}</Button>
    ).bind(this)

    buttonGroup =
      <ButtonGroup>
        {buttons}
      </ButtonGroup>

    <FormEntry entry={buttonGroup} {...@props} />
