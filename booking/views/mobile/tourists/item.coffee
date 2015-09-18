define [
  'components/tour/booking/views/default/tourists/item'
  'components/tour/booking/templates/mobile/tourists/item'

], (DefaultTouristItemView, MobileTouristTemplate) ->

  class MobileTouristItemView extends DefaultTouristItemView

    className: 'panel panel-default tour-booking-tourist'

    template: MobileTouristTemplate