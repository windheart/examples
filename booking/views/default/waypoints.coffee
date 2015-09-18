define [
  'marionette2'
  'backbone'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/waypoints'
  'components/tour/booking/collections/waypoint'
  'components/tour/booking/views/default/waypoints/item'

], (Marionette, Backbone, channel, WaypointsTemplate, waypointCollection, WaypointItemView) ->

  class WaypointsView extends Marionette.CompositeView

    className: 'row tour-booking-section'

    template: WaypointsTemplate

    model: new Backbone.Model

    collection: waypointCollection

    childView: WaypointItemView

    childViewContainer: '.tour-booking-waypoint-collection'


    addChild: (itemModel, ItemView, index) ->
      if itemModel.isEditable() then return super(itemModel, ItemView, index)


