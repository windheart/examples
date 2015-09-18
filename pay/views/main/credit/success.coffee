define [
  'components/core/events'
  'marionette'
  'components/pay/models/credit'
  'components/pay/templates/main/credit/success'
  'components/pay/views/main/credit'

], (events, Marionette, creditModel, CreditSuccessTemplate, CreditView) ->

  class CreditSuccessView extends Marionette.ItemView

    model: creditModel

    template: CreditSuccessTemplate

    events:
      'click  .pay-credit-complete': 'close'


    onClose: ->
      events.trigger('content:show', new CreditView)


  return CreditSuccessView