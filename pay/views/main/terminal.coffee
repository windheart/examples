define [
  'marionette'
  'components/pay/models/terminal'
  'components/pay/templates/main/terminal'

], (Marionette, terminalModel, TerminalTemplate) ->

  class TerminalView extends Marionette.ItemView

    template: TerminalTemplate

    model: terminalModel


  return TerminalView