define [
  'backbone'
  'components/pay/models/default'
  'baseModel'
], (Backbone, coreModel, BaseModel) ->

  class FormModel extends Backbone.Model


    defaults:
      'dgCode'                 : coreModel.get('dgCode') or ''
      'originalSum'            : coreModel.get('originalSum')
      'sum'                    : coreModel.get('sum') or null
      'currentCurrencyId'      : coreModel.get('currency') or 'rub'
      'currencies'             : coreModel.get('currencies')
      'lockOrder'              : !!coreModel.get('dgCode')
      'lockSum'                : !!coreModel.get('originalSum') and !!coreModel.get('currency')
      'error'                  : null
      'hash'                   : ''

    url: "#{coreModel.get('baseUrl')}/index/clearing"

    validation:
      dgCode:
        required: true
        msg: 'Укажите код брони'
      originalSum:
        fn: 'validateSum'

    toJSON: () ->
      data = super
      _.each(data, (val, key) ->
        data[key] = if _.isObject(val) and _.isFunction(val.toJSON) then val.toJSON() else val
      )

      return data

    toRedirect: () =>
      return "#{coreModel.get('baseUrl')}/index/save"

    initialize: (attrs) ->
      _.each(attrs, (val, key) =>
        if _.isArray(val) and val[0] and _.isObject(val[0])
          @set(key, new Backbone.Collection(val))
        else
          @set(key, val)
      )

      return

    validateSum: (val) ->
      isValid = parseFloat(val) > 0
      msg = 'Неправильно указана сумма к оплате'
      return if isValid then null else msg





