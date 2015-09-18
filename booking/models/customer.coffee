define [
  'baseModel'

], (BaseModel) ->

  class CustomerModel extends BaseModel

    defaults:
      name       : ''
      email      : ''
      phone      : ''
      comment    : ''

      type       : 'client'
      login      : ''
      password   : ''
      status     : ''
      message    : ''

      # Комиссия агентства в процентах
      comission  : 0

      registrationUrl: 'http://customer.dsbw.ru/#agency/new'

      checkStatus: true

    url: '/tour/customer-auth'


    fetch: ->
      return super(
        'dataType': 'json'
        'data': @toJSON()
      )


  return new CustomerModel