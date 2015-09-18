define [
  'marionette2'
  'components/tour/booking/templates/default/status'

], (Marionette, StatusTemplate) ->

  class StatusView extends Marionette.ItemView

    className: 'row tour-booking-section tour-booking-status'

    template: StatusTemplate


