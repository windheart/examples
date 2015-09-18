define [
  'baseModel'

], (BaseModel) ->

  class RecoverPasswordModel extends BaseModel

    defaults:
      'message': ''
      'status' : ''
      'email'  : ''

    url: '/tour/recover-password'


    fetch: ->
      return super(
        'dataType': 'json'
        'data': @pick('email')
      )
