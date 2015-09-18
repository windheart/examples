define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/price'
  'components/tour/booking/models/price'
  'components/tour/booking/models/default'
  'components/tour/booking/models/customer'
  'components/core/utils/text'
  'moment'

], (Marionette, channel, PriceTemplate, priceModel, defaultModel, customerModel, textUtil, moment) ->

  class PriceView extends Marionette.ItemView

    className: 'row tour-booking-section'

    template: PriceTemplate

    templateHelpers:
      getTotal: (total, currency, value, comission) ->
        sum = total
        if comission
          sum = Math.round(total - (value * comission / 100))

        priceValue = textUtil.numberFormat(sum, 0, '.', ' ')

        if currency
          priceValue += " #{currency}"

        return priceValue

      getDate: (day) ->
        format = 'D MMMM YYYY'
        if day is 'today'
          return moment().format(format)
        else
          return moment().add(1, 'days').format(format)

      getPriceInRub: (total, rate, format, value, comission) ->
        sum = Math.round(total * rate)
        if comission
          sum = Math.round((total - (value * comission / 100)) * rate)

        if format is 'text'
          return "#{textUtil.numberToWords(sum)} #{textUtil.numberSuffix(sum, 'рубль', 'рубля', 'рублей')}"
        else
          return "#{textUtil.numberFormat(sum, 0, '.', ' ')} #{textUtil.numberSuffix(sum, 'рубль', 'рубля', 'рублей')}"

      getComissionInMoney: (value, comission, currency) ->
        sum = Math.round(value * comission / 100)

        return "#{sum} #{currency}"

      isSelected: (arg1, arg2) ->
        if arg1 is arg2 then return 'selected="selected"'


    model: priceModel

    events:
      'click .tour-booking-price-list-show': '_showPriceList'
      'change .form-control': '_change'

    modelEvents:
      'change': 'render'


    initialize: ->
      @listenTo(channel.vent, 'after:change:extraServiceModel logged:customer', @render)
      @listenTo(channel.vent, 'after:prepare:touristCollection after:sync:promoModel', @_syncModel)

      channel.vent.trigger('after:initialize:priceView')


    _showPriceList: (event) ->
      event.preventDefault()
      channel.vent.trigger('before:show:priceListView', {'showExtraServices' : true})


    _change: (event) ->
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), ctrl.val())


    serializeData: ->
      return _.extend(@model.toJSON(),
        extra    : @model.getExtra()
        total    : @model.getTotal()
        comission: customerModel.get('comission')
        isLocal  : defaultModel.get('isLocal')
      )


    _syncModel: ->
      @model.fetch().done( =>
        channel.vent.trigger('after:change:priceModel')
      )