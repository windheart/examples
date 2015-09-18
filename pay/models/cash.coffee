define [
  'components/pay/models/default'
  'backbone'

], (defaultModel, Backbone) ->

  class CashModel extends Backbone.Model

    defaults:
      'eurRate'    : defaultModel.get('eurRate')
      'eurPrefRate': defaultModel.get('eurPrefRate')
      'usdRate'    : defaultModel.get('usdRate')
      'usdPrefRate': defaultModel.get('usdPrefRate')
      'currentDate': defaultModel.get('currentDate')

      'zoom': 16
      'x'   : 37.633576
      'y'   : 55.755822


  return new CashModel