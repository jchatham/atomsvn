{View} = require 'atom'

class BranchBriefView extends View
  @content: ->
    @div class: 'branch-brief-view', mousedown: 'clicked', =>
      @div class: 'name', outlet: 'name'
      @div class: 'commit', outlet: 'commit'

  initialize: (@model) ->
    @model.on 'change:selected', @showSelection
    @model.on 'update', @repaint
    @repaint()

  beforeRemove: =>
    @model.off 'change:selected', @showSelection
    @model.off 'update', @repaint

  clicked: =>
    @model.selfSelect()

  repaint: =>
    @name.html("#{@model.name()}")
    @commit.html("(#{@model.commit().shortID()}: #{@model.commit().shortMessage()})")

    @commit.removeClass 'unpushed'
    if @model.unpushed()
      @commit.addClass 'unpushed'

    @showSelection()

  showSelection: =>
    @removeClass('selected')
    @addClass('selected') if @model.isSelected()

module.exports = BranchBriefView
