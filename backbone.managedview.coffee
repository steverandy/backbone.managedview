class Backbone.ManagedView extends Backbone.View
  _configure: (options) ->
    @views ||= {}
    if options.views
      @views = options.views
    if options.insert
      @insert = options.insert
    if _(@insert).isFunction()
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
    @$el.html @template?(this)
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
    _(@views).each (view, name) =>
      if _(view).isArray()
        for viewChild in view
          views.push viewChild
      else
        views.push view
    return views

  # Render all view instances in @views and insert them to the DOM
  renderViews: =>
    _(@views).each (view, name) =>
      $el = @$ name
      $el = @$el if name.length is 0
      if _.isArray view
        insert = view[0]?.insert or "append"
        _.invoke view, "render"
        $el[insert] _.pluck(view, "el")
      else
        view.render()
        unless view.insert
          $el.replaceWith view.el

  # Remove all view instances in @views
  removeViews: =>
    _.invoke @collectViews(), "remove"
    @views = {}

Backbone.View = Backbone.ManagedView
