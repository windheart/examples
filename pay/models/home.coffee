define [
  'components/pay/models/default'
  'backbone'

], (coreModel, Backbone) ->

  class HomeModel extends Backbone.Model

    defaults:
      'dgCode'         : coreModel.get('dgCode')
      'originalSum'    : coreModel.get('originalSum')
      'currency'       : coreModel.get('currency')
      'hasCreditAccess': coreModel.get('hasCreditAccess')

      'usdRate'    : coreModel.get('usdRate')
      'usdPrefRate': coreModel.get('usdPrefRate')

      'eurRate'        : coreModel.get('eurRate')
      'eurPrefRate'    : coreModel.get('eurPrefRate')

      'eurDiscountRate': coreModel.get('eurDiscountRate')

      'currentDate' : coreModel.get('currentDate')
      'tomorrowDate': coreModel.get('tomorrowDate')

      'tomorrowUsdRate'    : coreModel.get('tomorrowUsdRate')
      'tomorrowUsdPrefRate': coreModel.get('tomorrowUsdPrefRate')

      'tomorrowEurRate'    : coreModel.get('tomorrowEurRate')
      'tomorrowEurPrefRate': coreModel.get('tomorrowEurPrefRate')
      'tomorrowEurDiscountRate': coreModel.get('tomorrowEurDiscountRate')


  return new HomeModel