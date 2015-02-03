shellescape = require 'shell-escape'
tmp         = require 'temporary'

module.exports =
  class DiffHelper
    treeView: null

    baseCommand: 'diff --strip-trailing-cr --label "left" --label "right" -u '

    constructor: (treeViewPanel)->
      @treeView = treeViewPanel

    selectedFiles: ->
      if @treeView is null
        console.error 'tree-view not found or already set'
        return
      else
        @treeView.selectedPaths()

    execDiff: (files, kallback) ->
      cmd  = @buildCommand(files)
      exec = require('child_process').exec
      exec cmd, kallback

    buildCommand: (files) ->
      if files.length > 2
        throw "Error"

      @baseCommand + shellescape(files)

    createTempFile: (contents) ->
      tmpfile = new tmp.File()
      tmpfile.writeFileSync(contents)
      tmpfile.path

    createTempFileFromClipboard: (clipboard) ->
      tmpfile = new tmp.File()
      tmpfile.writeFileSync(clipboard.read())
      tmpfile.path
