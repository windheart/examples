define [
  'marionette'
  'components/pay/models/card'
  'components/pay/templates/main/card/error'

], (Marionette, cardModel, CardErrorTemplate) ->

  class CardErrorView extends Marionette.ItemView

    model: cardModel

    template: CardErrorTemplate


  return CardErrorView