define [
  'marionette2'
  'backbone'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/price/list'
  'components/tour/booking/collections/extra-service'
  'components/tour/booking/models/price'
  'components/core/utils/text'

], (Marionette, Backbone, channel, PriceListTemplate, extraServiceCollection, priceModel, textUtil) ->

  class PriceListView extends Marionette.ItemView

    className: 'modal-dialog'

    template: PriceListTemplate

    templateHelpers:
      getServiceHighlightClass: (service) ->
        highlightClasses = {
          '1137': 'text-danger'
          '1'   : 'text-info'
          '4'   : 'text-warning'
          '1270': 'text-warning'
          '1272': 'text-warning'
          '3'   : 'text-success'
          '7'   : 'text-success'
        }

        return highlightClasses[service.type] or ''


      price: (value) ->
        return textUtil.numberFormat(value, 0 , '', ' ')


      isDiscount: (service) ->
        return service.type is 1137


    serializeData: ->
      return _.extend(@model.toJSON(),
        'package': priceModel.get('package')
        'extra'  : extraServiceCollection.map((extraService) ->
          return {
            'name'    : extraService.get('name')
            'price'   : extraService.get('price').value
            'quantity': extraService.get('currentTouristQuantity')
            'type'    : extraService.get('type')
          }
        )
        'total'   : if @model.get('showExtraServices') then priceModel.getTotal() else priceModel.get('value')
        'currency': priceModel.get('currency')
        'currencySymbol': priceModel.get('currencySymbol')
      )


    onRender: ->
      channel.vent.trigger('show:modal')
