define [
  'components/tour/booking/views/default/waypoints'
  'components/tour/booking/templates/mobile/waypoints'
  'components/tour/booking/views/mobile/waypoints/item'

], (DefaultWaypointsView, MobileWaypointsTemplate, MobileWaypointItemView) ->

  class MobileWaypointsView extends DefaultWaypointsView

    className: 'list-group-item tour-booking-section'

    template: MobileWaypointsTemplate

    childView: MobileWaypointItemView