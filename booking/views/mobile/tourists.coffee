define [
  'components/tour/booking/views/default/tourists'
  'components/tour/booking/templates/mobile/tourists'
  'components/tour/booking/views/mobile/tourists/item'

], (DefaultTouristsView, MobileTouristsTemplate, MobileTouristItemView) ->

  class MobileTouristsView extends DefaultTouristsView

    className: 'list-group-item tour-booking-section'

    template: MobileTouristsTemplate

    childView: MobileTouristItemView