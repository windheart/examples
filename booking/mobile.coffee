define [
  'marionette2'
  'components/tour/booking/channel'
  'components/core/layout2'
  'components/tour/booking/views/mobile'
  'components/tour/booking/models/default'
  'components/tour/booking/models/tour'
  'components/tour/booking/models/date'
  'components/core/utils/http'

], (Marionette, channel, layout, DefaultView, defaultModel, tourModel, dateModel, httpUtil) ->

  class TourBookingMobile extends Marionette.Object

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

      defaultModel.fetch().always((response, text, xhr) =>
        if text isnt 'success'
          defaultModel.set('status', 'error')
        layout.getRegion('booking').attachView(new DefaultView({'model': defaultModel}))
      )