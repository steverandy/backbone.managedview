# backbone.managedview

It is an extension for Backbone.View, which adds views management logic and structure.

## Usage

backbone.managedview adds properties and methods to Backbone.View

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
insert: "append"
```

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
