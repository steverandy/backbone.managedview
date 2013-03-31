class Backbone.ManagedView extends Backbone.View
  _configure: (options) ->
    @views ||= {}
    if options.views
      @views = options.views
    if options.insert
      @insert = options.insert
    if _.isFunction @insert
      @insertOnce = _.once @insert
    super

  # Render view and its sub-views
  render: =>
    unless @manage
      super
      return
    @beforeRender?()
    @insertOnce?()
    @delegateEvents()
    @$el.empty().append @template?(this)
    @renderViews()
    @afterRender?()
    @trigger "render"
    return this

  # Remove view and its sub-views
  remove: =>
    unless @manage
      super
      return
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
    _.invoke @collectViews(), "remove"
    @views = {}

Backbone.View = Backbone.ManagedView
