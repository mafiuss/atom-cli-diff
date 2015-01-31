DiffView = require "./diff-view"
DiffHelper = require './helpers/diff-helper'

module.exports =
  diffHelper: null
  diffView: null

  activate: (state) ->
    atom.commands.add 'atom-workspace', 'diff:selected', => @selected()
    atom.commands.add 'atom-workspace', 'diff:clipboard', => @clipboard()

    @diffHelper = new DiffHelper atom.views.getView(atom.workspace)

    if @diffView != null and @diffView.hasParent()
      @diffView.destroy()
    else
      @diffView = new DiffView(state)

  deactivate: ->
    @diffView.destroy()
    @diffHelper = null

  serialize: ->
    diffViewState: @diffView.serialize()

  selected: ->
    selectedPaths = @diffHelper.selectedFiles()

    if selectedPaths.length != 2
      console.error "wrong number of arguments for this command"
      throw "Error"

    p = @diffHelper.execDiff selectedPaths, (error, stdout, stderr) =>
        if (error != null)
          console.log "there was an error " + error
        atom.workspace.open(@diffHelper.createTempFile(stdout))

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
          atom.workspace.open(@diffHelper.createTempFile(stdout))
    else
      console.error "either there is no active editor or no clipboard data"
      throw "Error"
