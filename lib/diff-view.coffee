{ScrollView} = require 'atom'
DiffHelper = require './helpers/diff-helper'

module.exports =
class DiffView extends ScrollView


  myWorkspaceView: null
  diffHelper: null

  @content: ->
    @div class: 'diff-view'
  initialize: (state) ->
    super state
    @diffHelper = new DiffHelper(atom.workspaceView)

  serialize: ->

  destroy: ->
    @detach()

  selected: ->
    selectedPaths = @diffHelper.selectedFiles()

    if selectedPaths.length != 2
      console.error "wrong number of arguments for this command"
      throw "Error"

    p = @diffHelper.execDiff selectedPaths, (error, stdout, stderr) =>
        if (error != null)
          console.log "there was an error " + error
        atom.workspaceView.open(@diffHelper.createTempFile(stdout))

  clipboard: ->
    selectedPaths = [
      atom.workspace.activePaneItem.getPath(),
      @diffHelper.createTempFileFromClipboard(atom.clipboard)
    ]

    if selectedPaths.length != 2
      console.error "wrong number of arguments for this command"
      throw "Error"
    if selectedPaths[0]? and selectedPaths[1]?
      p = @diffHelper.execDiff selectedPaths, (error, stdout, stderr) =>
          if (error != null)
            console.log "there was an error " + error
          atom.workspaceView.open(@diffHelper.createTempFile(stdout))
    else
      console.error "either there is no active editor or no clipboard data"
      throw "Error"
