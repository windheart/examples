define [
  'components/tour/booking/views/default/date'
  'components/tour/booking/templates/mobile/date'

], (DefaultDateView, MobileDateTemplate) ->

  class MobileDateView extends DefaultDateView

    className: 'list-group-item tour-booking-section'

    template: MobileDateTemplate