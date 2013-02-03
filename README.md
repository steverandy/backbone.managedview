# backbone.managedview

It is an extension for Backbone.View, which adds views management logic and structure.

## Properties and Methods

### manage

When set to `true`, view rendering and removing will be managed. Set to `false` if you need the default behavior of Backbone.View.

### insert

For top level view, insert should be defined as a function.

```coffee
insert: =>
  $("body").append @el
```

For item view, insert should be defined as a string — `"append"` or `"prepend`. If not set by default the value will be set to `"append"`.

```coffee
insert: "prepend"
```

### views

`views` is a hash that keep track of subviews. The key is the name of the view or a selector where the view will inserted to the DOM. The value is the subview object itself.

```coffee
views:
  "header.main": new App.Views.Components.MainHeader
  "footer.main": new App.Views.Components.MainFooter
```

The `views` hash value can also be an array. This can be used when constructing list type view.

```coffee
listsView = new App.Views.Components.Lists
listsView.views["#lists"] = []
@lists.each (list) =>
  listsView.views["#lists"].push new App.Views.Components.List
    model: list
```

### beforeRender

Define this function and it will be called the first during rendering process before DOM insertion and template execution.

### afterRender

Define this function and it will be called after DOM insertion, template execution, and subviews rendering.

### beforeRemove

Define this function and it will be called the first during removing process.

### afterRemove

Define this function and it will be called after all subviews have been removed.

## Events

## render

Rendering steps:

1. Call `beforeRender`
2. Insert to DOM
3. Insert template
4. Render subviews
5. Call `afterRender`
6. Trigger `render` event

## remove

Removing steps:

1. Call `beforeRemove`
2. Remove subviews
3. Call super
4. Call `afterRemove`
5. Trigger `render` event

## Example

```coffee
  class App.Views.Layout extends Backbone.View
    id: "app"
    template: _.template("<header></header><div id='content'>test</div>")

    initialize: ->
      @insertCount = 0

    insert: =>
      $("body").append @el

    beforeRender: =>

    afterRender: =>
      console.log "rendered layout"
```

## Test Suite

Open `test/index.html` on a web browser to run the test suite.
