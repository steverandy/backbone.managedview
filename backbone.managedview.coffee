class Backbone.ManagedView extends Backbone.View
  _configure: (options) ->
    @views = options.views || {}
    super

  # Render view and its sub-views
  render: =>
    @beforeRender?()
    @insert?()
    @$el.html @template?(this)
    @renderViews()
    @afterRender?()
    @trigger "render"
    return this

  # Remove view and its sub-views
  remove: =>
    super
    @removeViews()
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
      if _(view).isArray()
        for childView in view
          unless childView.insert? @$(name)
            @$(name).append childView.el
          childView.render()
      else
        @$(name).replaceWith view.el
        view.render()

  # Remove all view instances in @views
  removeViews: =>
    view.remove() for view in @collectViews()
