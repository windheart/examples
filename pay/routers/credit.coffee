define [
  'marionette'
  'components/pay/controllers/credit'

], (Marionette, creditController) ->

  class CreditRouter extends Marionette.AppRouter

    appRoutes:
      'credit'        : 'default'
      'credit/process': 'process'

    controller: creditController


  return new CreditRouter