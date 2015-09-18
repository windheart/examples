define [
  'marionette'
  'components/pay/controllers/card'

], (Marionette, cardController) ->

  class CardRouter extends Marionette.AppRouter

    appRoutes:
      'card'              : 'default'
      'card/process?*path': 'process'

    controller: cardController


  return new CardRouter