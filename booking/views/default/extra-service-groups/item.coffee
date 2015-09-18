define [
  'marionette2'
  'backbone',
  'components/tour/booking/templates/default/extra-service-groups/item'
  'components/tour/booking/collections/extra-service'
  'components/tour/booking/views/default/extra-service-groups/item/service'

], (Marionette, Backbone, ExtraServiceGroupItemTemplate, extraServiceCollection, ExtraServiceItemView) ->

  class ExtraServiceGroupItemView extends Marionette.CompositeView

    template: ExtraServiceGroupItemTemplate

    collection: extraServiceCollection

    childView: ExtraServiceItemView

    childViewContainer: '.tour-booking-extra-service-collection'


    initialize: ->
      @collection = new Backbone.Collection(@collection.filter((service) => return service.get('groupId') is @model.id))
