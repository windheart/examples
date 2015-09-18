define [
  'backbone'
  'components/tour/booking/models/date'
  'moment'

], (Backbone, dateModel, moment) ->

  class TouristModel extends Backbone.Model

    defaults:
      'sex'              : 0
      'firstNameRu'      : ''
      'lastNameRu'       : ''
      'firstName'        : ''
      'lastName'         : ''
      'birthday'         : ''
      'passportSeries'   : ''
      'passportNumber'   : ''
      'passportValidTill': ''
      'isSocial'         : false
      'facebook'         : ''
      'vkontakte'        : ''
      'instagram'        : ''


    # Возраст туриста на дату начала тура
    getAge: ->
      birthday  = moment(@get('birthday'), 'DD.MM.YYYY')
      tourBegin = moment(dateModel.get('currentVariantId'), 'YYYY-MM-DD')

      return tourBegin.diff(birthday, 'years')