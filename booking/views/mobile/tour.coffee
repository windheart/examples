define [
  'components/tour/booking/views/default/tour'
  'components/tour/booking/templates/mobile/tour'

], (DefaultTourView, MobileTourTemplate) ->

  class MobileTourView extends DefaultTourView

    className: 'list-group-item tour-booking-section'

    template: MobileTourTemplate