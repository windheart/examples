define [
  'backbone'
  'components/tour/booking/channel'

], (Backbone, channel) ->

  class PromoModel extends Backbone.Model

    defaults:
      'code': ''
      'status': ''
      'message': ''

    url: '/tour/booking-promo'


    initialize: ->
      channel.reqres.setHandler('promoCode', => return @get('code'))


    validate: (attrs) ->
      if not attrs.code
        return 'Пожалуйста, введите промокод'
