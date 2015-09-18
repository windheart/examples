define [
  'components/pay/models/default'
  'baseModel'
], (coreModel, BaseModel) ->

  class ClearingModel extends BaseModel

    defaults:
      'dgCode'                 : coreModel.get('dgCode') or ''
      'isAgency'               : coreModel.get('isAgency') or false
      'originalSum'            : coreModel.get('originalSum')
      'sum'                    : coreModel.get('sum') or null
      'currentCurrencyId'      : coreModel.get('currency') or 'rub'
      'currencies'             : coreModel.get('currencies')
      'lockOrder'              : !!coreModel.get('dgCode')
      'lockSum'                : !!coreModel.get('originalSum') and !!coreModel.get('currency')


  return new ClearingModel