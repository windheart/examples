define [
  'components/core/env'
  'backbone'
  'baseModel'

], (env, Backbone, BaseModel) ->

  class DefaultModel extends BaseModel

    defaults:
      'baseUrl'        : "#{document.location.protocol}//#{document.location.host}"
      'dgCode'         : env.request('bootstrap', 'dgCode')
      'dgCodeIsValid'  : env.request('bootstrap', 'dgCodeIsValid')
      'currency'       : env.request('bootstrap', 'currency')
      'originalSum'    : env.request('bootstrap', 'originalSum')
      'sum'            : env.request('bootstrap', 'sum')
      'hasCreditAccess': env.request('bootstrap', 'hasCreditAccess')
      'hasProfile'     : env.request('bootstrap', 'hasProfile')
      'isAgency'       : env.request('bootstrap', 'isAgency')
      'currencies' : new Backbone.Collection([
        {'id': 'rub', 'name': 'руб.',   'rate': 1}
        {'id': 'eur', 'name': '&euro;', 'rate': env.request('bootstrap', 'eurRate')}
        {'id': 'usd', 'name': '$',      'rate': env.request('bootstrap', 'usdRate')}
      ])

      'usdRate'        : env.request('bootstrap', 'usdRate')
      'usdPrefRate'    : env.request('bootstrap', 'usdPrefRate')

      'eurRate'        : env.request('bootstrap', 'eurRate')
      'eurPrefRate'    : env.request('bootstrap', 'eurPrefRate')
      'eurDiscountRate': env.request('bootstrap', 'eurDiscountRate')

      'currentDate'    : env.request('bootstrap', 'currentDate')
      'tomorrowDate'   : env.request('bootstrap', 'tomorrowDate')

      'tomorrowUsdRate': env.request('bootstrap', 'tomorrowUsdRate')
      'tomorrowUsdPrefRate': env.request('bootstrap', 'tomorrowUsdPrefRate')

      'tomorrowEurRate': env.request('bootstrap', 'tomorrowEurRate')
      'tomorrowEurPrefRate': env.request('bootstrap', 'tomorrowEurPrefRate')
      'tomorrowEurDiscountRate': env.request('bootstrap', 'tomorrowEurDiscountRate')

      'disableOld'     : env.request('bootstrap', 'disableOld') or false
      'oldUrl'         : 'https://pay.dsbw.ru/index/index'
      'search'         : env.request('bootstrap', 'search')


  return new DefaultModel