define [
  'marionette2'
  'components/tour/booking/channel'

], (Marionette, channel) ->

  class ModalView extends Marionette.ItemView

    className: 'modal-dialog'


    onRender: ->
      channel.vent.trigger('show:modal')