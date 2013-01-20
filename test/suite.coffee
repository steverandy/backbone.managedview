$ =>
  module "default variables"

  test "views", =>
    view = new Backbone.ManagedView
    view.views["header"] = "headerView"
    equal view.views["header"], "headerView"

  module "render",
    setup: =>
      class @Layout extends Backbone.ManagedView
        id: "app"
        template: _.template("<header></header><div id='content'>test</div>")
        initialize: ->
          @insertCount = 0
        insert: =>
          $("body").append @el
          @insertCount += 1
        beforeRender: =>
          @beforeRenderCalled = true
        afterRender: =>
          @afterRenderCalled = true

      class @Header extends Backbone.ManagedView
        tagName: "header"
        template: _.template("<p>header</p><div id='items'></div>")
        beforeRender: =>
          _(@views["#items"]).invoke "remove"
          @views["#items"] = []
          @views["#items"].push new Item
          @views["#items"].push new Item

      class @Item extends Backbone.ManagedView
        className: "item"
        insert: "prepend"
        template: _.template("<p>item name</p>")

    teardown: =>
      $("#app").remove()

  test "render view", =>
    layout = new Layout
    layout.render()
    equal "test", $("#app #content").html()

  test "render view and subviews", =>
    layout = new Layout
    layout.views["header"] = new Header
    layout.render()
    equal $("#app #content").html(), "test"
    equal $("#app header p").html(), "header"
    equal $("#app header #items .item").length, 2
    layout.render()
    equal $("#app #content").html(), "test"
    equal $("#app header p").html(), "header"
    equal $("#app header #items .item").length, 2

  test "beforeRender", =>
    layout = new Layout
    equal layout.beforeRenderCalled, undefined
    layout.render()
    equal layout.beforeRenderCalled, true

  test "afterRender", =>
    layout = new Layout
    equal layout.afterRenderCalled, undefined
    layout.render()
    equal layout.afterRenderCalled, true

  test "insert only once", =>
    layout = new Layout
    equal layout.insertCount, 0
    layout.render()
    equal layout.insertCount, 1
    layout.render()
    equal layout.insertCount, 1

  module "remove",
    setup: =>
      class @Layout extends Backbone.ManagedView
        id: "app"
        template: _.template("<header></header><div id='content'>test</div>")
        insert: =>
          $("body").append @el
        afterRemove: =>
          @afterRemoveCalled = true

      class @Header extends Backbone.ManagedView
        tagName: "header"
        template: _.template("<p>header</p>")

    teardown: =>
      $("#app").remove()

  test "remove view", =>
    layout = new Layout
    layout.render()
    equal $("#app #content").length, 1
    layout.remove()
    equal $("#app #content").length, 0
    equal $("#app").length, 0

  test "remove view and subviews", =>
    layout = new Layout
    layout.views["header"] = new Header
    layout.render()
    equal $("#app #content").length, 1
    equal $("#app header p").length, 1
    layout.remove()
    equal $("#app #content").length, 0
    equal $("#app header p").length, 0

  test "afterRemove", =>
    layout = new Layout
    layout.render()
    equal layout.afterRemoveCalled, undefined
    layout.remove()
    equal layout.afterRemoveCalled, true

  module "utility functions",
    setup: =>
      class @Layout extends Backbone.ManagedView
      class @Header extends Backbone.ManagedView
      class @Footer extends Backbone.ManagedView
      class @Item extends Backbone.ManagedView
    teardown: =>

  test "collectViews", =>
    layout = new Layout
    header = new Header
    footer = new Footer
    item1 = new Item
    item2 = new Item
    layout.views["header"] = header
    layout.views["footer"] = footer
    layout.views[".items"] = [item1, item2]
    deepEqual layout.collectViews(), [header, footer, item1, item2]
