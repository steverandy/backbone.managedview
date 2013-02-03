# backbone.managedview

It is an extension for Backbone.View, which adds views management logic and structure. It's common for a view to have multiple subviews, but in Backbone.View managing subviews has to be done manually. This extension manages rendering a view and its subviews. When a view is removed, this extension also manages the subviews removal.

## API

### manage

When set to `true`, view rendering and removing will be managed. Set to `false` if you need the default behavior of Backbone.View.

### insert

It determines how a view will be inserted to the DOM. For top level view, insert should be defined as a function.

```coffee
insert: =>
  $("body").append @el
```

For item view, insert should be defined as a string — `"append"` or `"prepend"`. The default value is `"append"`.

```coffee
insert: "prepend"
```

### views

It is a hash that keeps track of subviews. The key is the name of the view or a selector where the view will inserted to the DOM. The value is the subview object itself.

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

It will be called the first during [rendering process](#rendering-process). Define this function when actions need to be performed before view element is inserted to the DOM or before template is executed.

### afterRender

It will be called the last during [rendering process](#rendering-process). Define this functon when actions need to be performed after view element has been inserted to the DOM, template has been executed and subviews have been rendered. For example to setup a jQuery sortable.

### beforeRemove

It will be called the first during [removing process](#removing-process).

### afterRemove

It will be called the last during [removing process](#removing-process).

## Events

There are two events — `render` and `remove`. Use events when actions cannot be performed in the rendering or removing callbacks.

## Rendering Process

`render` function is predefined, therefore there is no need to define it manually. Rendering process uses the following steps:

1. Call `beforeRender`
2. Insert to DOM
3. Insert template
4. Render subviews
5. Call `afterRender`
6. Trigger `render` event

## Removing Process

`remove` function is also prefined like `render`. The process uses the following steps:

1. Call `beforeRemove`
2. Remove subviews
3. Call super
4. Call `afterRemove`
5. Trigger `render` event

## Example

```coffee
  class App.Views.Layout extends Backbone.View
    id: "app"
    template: _.template("<header></header><div id='content'></div><footer></footer>")
    manage: true
    views:
      "header": new App.Views.Components.Header
      "footer": new App.Views.Components.Footer

    insert: =>
      $("body").append @el

    afterRender: =>
      console.log "rendered layout"
```

## Test Suite

Open `test/index.html` on a web browser to run the test suite.
