define [
  'components/tour/booking/views/default/waypoints/item/room'
  'components/tour/booking/templates/mobile/waypoints/item/room'

], (DefaultRoomView, MobileRoomTemplate) ->

  class MobileRoomView extends DefaultRoomView

    className: 'tour-booking-room'

    template: MobileRoomTemplate