{View, EditorView} = require 'atom'
FileListView = require './file-list-view'
BranchBriefView = require './branch-brief-view'
BranchListView = require './branch-list-view'

module.exports =
class RepoView extends View
  @content: (repo) ->
    @div class: 'atomatigit', =>
      @subview "branch_brief_view", new BranchBriefView repo.current_branch
      #@textarea class: "block-input", outlet: "block_input"
      #@input class: "line-input", outlet: "block_input"
      @subview "block_input", new EditorView(mini: true)
      @subview "file_list_view", new FileListView repo.file_list
      @subview "branch_list_view", new BranchListView repo.branch_list

  initialize: (repo) ->
    @repo = repo
    @block_input.addClass "block-input"
    @insert_commands()
    @repo.on "need_input", @get_input
    @on 'core:confirm', => @complete_input()
    @on 'core:cancel', => @cancel_input()
    @on 'click', => @focus()
    @file_list_view.on "focusout", => @unfocus()

    atom_git = atom.project.getRepo()
    @subscribe atom_git, 'status-changed', => @repo.refresh()

  insert_commands: ->
    atom.workspaceView.command "atomatigit:next", => @repo.file_list.next()
    atom.workspaceView.command "atomatigit:previous", => @repo.file_list.previous()
    atom.workspaceView.command "atomatigit:stage", => @repo.stage()
    atom.workspaceView.command "atomatigit:unstage", => @repo.unstage()
    atom.workspaceView.command "atomatigit:kill", => @repo.kill()
    atom.workspaceView.command "atomatigit:open", => @repo.open()
    atom.workspaceView.command "atomatigit:toggle_file_diff", => @repo.toggle_file_diff()
    atom.workspaceView.command "atomatigit:commit", => @repo.initiate_commit()
    atom.workspaceView.command "atomatigit:push", => @repo.push()

  get_input: (callback) =>
    @input_callback = callback
    @block_input.setText ""
    @block_input.addClass "active"
    @block_input.focus()

  complete_input: ->
    @block_input.removeClass "active"
    @input_callback @block_input.getText()
    @focus()

  cancel_input: ->
    @block_input.removeClass "active"
    @input_callback = null
    @focus()

  focus: ->
    @addClass "focused"
    @file_list_view.focus()

  unfocus: ->
    @removeClass "focused"

  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
