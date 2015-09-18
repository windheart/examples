define [
  'components/core/events'
  'marionette'
  'components/pay/models/card'
  'components/pay/templates/main/card/success'
  'components/pay/views/main/card'

], (events, Marionette, cardModel, CardSuccessTemplate, CardView) ->

  class CardSuccessView extends Marionette.ItemView

    model: cardModel

    template: CardSuccessTemplate

    events:
      'click  .pay-card-complete': 'close'


    onClose: ->
      events.trigger('content:show', new CardView)


  return CardSuccessView