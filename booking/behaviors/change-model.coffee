define [
  'marionette2'

], (Marionette) ->

  class ChangeModelBehavior extends Marionette.Behavior

    events:
      'change .form-control': '_changeModel'


    _changeModel: (event) ->
      ctrl = @$(event.currentTarget)
      @view.model.set(ctrl.prop('name'), ctrl.val() or ctrl.data('value'))
