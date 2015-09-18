define [
  'components/pay/models/default'
  'backbone'
  'baseModel'

], (coreModel, Backbone, BaseModel) ->

  class CreditModel extends BaseModel

    defaults:
      'id'               : 'info'
      'status'           : 'pending'
      'agency'           : ''
      'limit'            : 0
      'available'        : 0
      'overdue'          : 0
      'currency'         : new Backbone.Model({'id': 'rub', 'name': 'руб.', 'rate': 1})
      'error'            : ''
      'originalSum'      : coreModel.get('originalSum') or null
      'sum'              : coreModel.get('sum') or null
      'dgCode'           : coreModel.get('dgCode')
      'currentCurrencyId': coreModel.get('currency') or 'rub'
      'currencies'       : coreModel.get('currencies')
      'errorMessage'     : ''
      'paymentId'        : ''
      'paymentDate'      : ''
      'sumPayed'         : 0
      'sumRemaining'     : 0
      'manager'          : ''
      'tourist'          : ''
      'hasProfile'       : coreModel.get('hasProfile')
      'lockOrder'        : !!coreModel.get('dgCode')

    urlRoot: "#{coreModel.get('baseUrl')}/credit"


    resetProcessingData: ->
      @set(
        'id'            : 'info'
        'isSuccess'     : ''
        'errorMessage'  : ''
        'paymentId'     : ''
        'paymentDate'   : ''
        'sumPayed'      : 0
        'sumRemaining'  : 0
        'manager'       : ''
        'tourist'       : ''
      )

      return @


    fetch: ->
      return super(
        'dataType': 'json'
        'data': @toQuery()
      )


    parse: (response) ->
      if @id is 'info' and not response.errorMessage
        map =
          'limit'    : 'creditLimit'
          'available': 'possibleCredit'
          'overdue'  : 'overduePayments'
          'currency' : 'creditLimitCurrency'

        _.each(map, (val, key) =>
          if key is 'currency' then return @set(key, @get('currencies').get(response[val].toLowerCase()))
          return @set(key, response[val])
        )

      return response


    toQuery: ->
      queryData = {}
      if @id is 'make-credit'
        json = @toJSON()
        queryData =
          'dgCode'           : json.dgCode
          'creditSum'        : json.originalSum
          'creditSumCurrency': json.currentCurrencyId.toUpperCase()

      return queryData


  return new CreditModel