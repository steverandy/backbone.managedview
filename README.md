# backbone.managedview

It is an extension for Backbone.View, which adds views management logic and structure.

## Usage

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
