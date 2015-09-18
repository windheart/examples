define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/package'
  'components/tour/booking/models/package'
  'components/tour/booking/models/default'
  'components/tour/booking/models/price'
  'components/tour/booking/collections/tourist'
  'components/core/utils/text'

], (Marionette, channel, PackageTemplate, packageModel, defaultModel, priceModel, touristCollection, textUtil) ->

  class PackageView extends Marionette.ItemView

    className: 'row tour-booking-section'

    template: PackageTemplate

    templateHelpers:
      getPackageItem: (item) ->
        return textUtil.ucfirst(item).replace(/;|\./g, '')
      getPrice: (price) ->
        return "#{textUtil.numberFormat(price.value, 0, '.', ' ')}  #{price.currencySymbol}"

    model: packageModel

    events:
      'click .tour-booking-price-list-show': '_showPriceList'


    initialize: ->
      @listenTo(channel.vent, 'after:change:priceModel', @render)


    _showPriceList: (event) ->
      event.preventDefault()
      channel.vent.trigger('before:show:priceListView', {'showExtraServices': false})


    serializeData: ->
      return _.extend(@model.toJSON(),
        'price': priceModel.toJSON()
        'showPricePerTourist': touristCollection.length > 1 && not priceModel.hasGroupRate()
        'isLocal': defaultModel.get('isLocal')
      )


