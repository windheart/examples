define [
  'backbone'
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/tech-support-form'

], (Backbone, Marionette, channel, TechSupportTemplate) ->

  class TechSupportFormView extends Marionette.ItemView

    className: 'modal-dialog'

    template: TechSupportTemplate

    templateHelpers: ->
      return {
      hasError: =>
        return @model.get('status') is 'error'

      hasSuccess: =>
        return @model.get('status') is 'success'
      }

    events:
      'change .form-control'     : 'changeModel'
      'click button[type=submit]': 'sync'
      'click button[type=button]': 'closeModal'


    onRender: ->
      channel.vent.trigger('show:modal')


    closeModal: ->
      channel.vent.trigger('close:modal')


    sync: (event) ->
      event.preventDefault()
      @model.fetch()


    changeModel: (event) ->
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), ctrl.val())