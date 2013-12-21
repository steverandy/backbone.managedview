class Backbone.View extends Backbone.View
  constructor: (options={}) ->
    @views = {}
    _.extend this, _.pick(options, ["views", "insert"])
    if _.isFunction @insert
      @insertOnce = _.once @insert
    super options

  # Render view and its sub-views
  render: =>
    unless @manage then return super
    if @filter?() then return false
    @insertOnce?()
    @delegateEvents()
    @beforeRender?()
    @$el.empty().append @template?(this)
    @renderViews()
    @afterRender?()
    @trigger "render"
    return this

  # Remove view and its sub-views
  remove: =>
    unless @manage then return super
    @beforeRemove?()
    @removeViews()
    super
    @afterRemove?()
    @trigger "remove"
    return this

  # Collect all view instances and return as a flat array
  collectViews: =>
    views = []
    for name, view of @views
      if _.isArray view
        for childView in view
          views.push childView
      else
        views.push view
    return views

  # Render all view instances in @views and insert them to the DOM
  renderViews: =>
    for name, view of @views
      $el = @$(name)
      $el = @$el if name.length is 0
      if _.isArray view
        for childView in view
          insert = childView.insert or "append"
          $el[insert] childView.el
          childView.render()
      else
        unless view.insert
          $el.replaceWith view.el
        view.render()

  # Remove all view instances in @views
  removeViews: =>
    for view in @collectViews()
      view?.remove?()
    @views = {}
