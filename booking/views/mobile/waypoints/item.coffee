define [
  'components/tour/booking/views/default/waypoints/item'
  'components/tour/booking/templates/mobile/waypoints/item'
  'components/tour/booking/views/mobile/waypoints/item/room'

], (DefaultWaypointItemView, MobileWaypointItemTemplate, MobileRoomView) ->

  class MobileWaypointItemView extends DefaultWaypointItemView

    className: 'panel panel-default tour-booking-waypoint'

    template: MobileWaypointItemTemplate

    childView: MobileRoomView