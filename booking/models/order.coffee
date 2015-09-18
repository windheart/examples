define [
  'baseModel'
  'components/tour/booking/channel'
  'components/tour/booking/models/price'
  'components/tour/booking/collections/extra-service'
  'components/tour/booking/models/tour'
  'components/tour/booking/models/date'
  'components/tour/booking/collections/tourist'
  'components/tour/booking/models/customer'

], (BaseModel, channel, priceModel, extraServiceCollection, tourModel, dateModel, touristCollection, customerModel) ->

  class OrderModel extends BaseModel

    defaults:
      'id'                : null
      'key'               : null
      'sum'               : null
      'currency'          : null
      'error'             : ''
      'validationResponse': true
      'showBusseat'       : false

    url: '/tour/booking-order'


    initialize: ->
      channel.reqres.setHandler('orderId', => return @get('id'))


    fetch: ->
      return super(
        'dataType': 'json'
        'data': @toQuery()
      )


    toQuery: ->
      extraServices = []
      extraServiceCollection.each((extraService) ->
        if extraService.get('currentTouristQuantity') > 0
          extraServices.push(
            'code'    : extraService.get('code')  or 0
            'code1'   : extraService.get('code1') or 0
            'code2'   : extraService.get('code2') or 0
            'lineId'  : extraService.get('lineId')
            'quantity': extraService.get('currentTouristQuantity')
          )
      )

      return _.extend(priceModel.toQuery(),
        'tourists'     : touristCollection.toJSON()
        'customer'     : customerModel.toJSON()
        'extraServices': extraServices
      )