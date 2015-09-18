define [
  'marionette2'
  'backbone'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/extra-service-groups'
  'components/tour/booking/collections/extra-service-group'
  'components/tour/booking/views/default/extra-service-groups/item'
  'components/tour/booking/models/price'
  'components/core/utils/text'

], (Marionette, Backbone, channel, ExtraServiceGroupCollectionTemplate, extraServiceGroupCollection, ExtraServiceGroupItemView, priceModel, textUtil) ->

  class ExtraServiceGroupCollectionView extends Marionette.CompositeView

    className: 'row tour-booking-section'

    template: ExtraServiceGroupCollectionTemplate

    templateHelpers:
      getPrice: (price) ->
        return "#{textUtil.numberFormat(price.value, 0, '.', ' ')}  #{price.currencySymbol}"

    model: new Backbone.Model

    collection: extraServiceGroupCollection

    childView: ExtraServiceGroupItemView

    childViewContainer: '#tour-booking-extra-service-group-collection'


    initialize: ->
      @listenTo(channel.vent, 'after:change:priceModel after:change:extraServiceModel', @render)


    serializeData: ->
      return _.extend(@model,
        price:
          value   : priceModel.getExtra()
          currency: priceModel.get('currency')
          currencySymbol: priceModel.get('currencySymbol')
      )



