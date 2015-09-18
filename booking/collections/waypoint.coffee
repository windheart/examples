define [
  'backbone'
  'components/tour/booking/models/waypoint'

], (Backbone, WaypointModel) ->

  class WaypointCollection extends Backbone.Collection

    model: WaypointModel


  return new WaypointCollection