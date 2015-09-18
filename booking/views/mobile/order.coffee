define [
  'components/tour/booking/views/default/order'
  'components/tour/booking/templates/mobile/order/error'
  'components/tour/booking/templates/mobile/order/default'
  'components/tour/booking/templates/mobile/order/success'

], (DefaultOrderView, OrderErrorTemplate, OrderDefaultTemplate, OrderSuccessTemplate) ->

  class MobileOrderView extends DefaultOrderView

    className: 'tour-booking-section'

    getTemplate: ->
      if not @model.id
        if @model.get('error')
          return OrderErrorTemplate
        else
          return OrderDefaultTemplate
      else
        return OrderSuccessTemplate