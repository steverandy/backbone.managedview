$ =>
  test "views", =>
    view = new Backbone.ManagedView
    view.views["header"] = "headerView"
    equal view.views["header"], "headerView"

  test "render", =>

  test "remove", =>

  test "collectViews", =>
    class header extends Backbone.ManagedView
    class footer extends Backbone.ManagedView
    class item extends Backbone.ManagedView
    view = new Backbone.ManagedView
    view.views["header"] = new header
    view.views["footer"] = new footer
    view.views[".items"] = [new item, new item, new item]
    views = view.collectViews()
    equal views.length, 5

  test "renderViews", =>

  test "removeViews", =>
