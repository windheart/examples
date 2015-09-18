define [
  'marionette2'
  'components/core/layout2'
  'components/tour/booking/views/default'
  'components/tour/booking/models/default'
  'components/tour/booking/models/tour'
  'components/tour/booking/models/date'
  'components/tour/booking/models/price'
  'components/core/utils/http'

], (Marionette, layout, DefaultView, defaultModel, tourModel, dateModel, priceModel, httpUtil) ->

  class TourBookingComponent extends Marionette.Controller

    initialize: ->
      layout.addRegion('booking', '#tour-booking-region')

      requestParams = httpUtil.getRequestParams()
      tourModel.set(
        'id': layout.booking.$el.data('currentTourId')
        'priceKey': layout.booking.$el.data('priceKey')
        'currentVariantId': requestParams.v
        'x' : requestParams.x
        'y' : requestParams.y
        'z' : requestParams.z
      )

      dateModel.set('currentVariantId', requestParams.d or layout.booking.$el.data('d'))
      defaultModel.set('isLocal', layout.getRegion('booking').$el.data('isLocal'))

      if requestParams.rate
        priceModel.set('currency', requestParams.rate)

      if defaultModel.get('status') isnt 'ready'
        defaultModel.fetch().always((response, text, xhr) =>
          layout.getRegion('booking').attachView(new DefaultView({'model': defaultModel}))
        )
      else
        layout.getRegion('booking').show({'model': defaultModel})

