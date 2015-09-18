define [
  'components/pay/component'
  'backbone'
  'marionette'
  'components/core/utils/http'
  'components/core/events'
  'components/pay/views/main/card'
  'components/pay/views/main/card/success'
  'components/pay/models/card'
  'components/common/views/status'

], (component, Backbone, Marionette, httpUtil, events, CardView, CardSuccessView, cardModel, StatusView) ->

  class CardController extends Marionette.Controller

    default: ->
      cardModel.resetProcessingData()
      events.trigger('triggerRoute', new CardView, 'card')


    process: (queryStr) ->
      events.trigger('triggerRoute', new StatusView, 'card')

      params = httpUtil.deparam(queryStr)

      dfdConfirm = component.makeRequest('confirmPayment', params)
      dfdConfirm.done(=>
        component.logCardUserAction('paymentSuccess')
        events.trigger('content:show', new CardSuccessView)
      ).fail((error) =>
        component.logCardUserAction(error)
        events.trigger('content:show', new CardView)
      ).always( =>
        Backbone.history.navigate('card', {'replace': true})
      )


  return new CardController