define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/error'

  'bootstrap.tooltip'

], (Marionette, channel, ErrorTemplate) ->

  class ErrorView extends Marionette.ItemView

    className: 'row tour-booking-section'

    template: ErrorTemplate

    events:
      'click .tour-booking-old-url': '_triggerOldUrlFollowEvent'


    _triggerOldUrlFollowEvent: (event) ->
      event.preventDefault()
      channel.vent.trigger('after:click:oldBookingLink')