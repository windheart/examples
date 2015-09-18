define [
  'backbone'

], (Backbone) ->

  class TerminalModel extends Backbone.Model

    defaults: ->
      terminalLinks:
        'tourPay'  : 'http://www.tourpay.ru/term.htm'
        'svyaznoy' : 'http://www.svyaznoy.ru/address_shops/?FILTER=4&SECTION_ID=0'
        'rapida'   : 'http://rapida.ru/private/payment-points'
        'payTravel': 'http://pay.travel/pay_places'

  return new TerminalModel

