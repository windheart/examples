define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/promo'
  'components/tour/booking/models/promo'
  'components/tour/booking/behaviors/change-model'
  'components/tour/booking/models/price'

  'bootstrap.tooltip'

], (Marionette, channel, PromoTemplate, PromoModel, ChangeModelBehavior, priceModel) ->

  class PromoView extends Marionette.ItemView

    className: 'row tour-booking-section'

    template: PromoTemplate

    model: new PromoModel

    events:
      'click #tour-booking-promo-check': '_checkCode'

    modelEvents:
      'invalid': '_showError'
      'sync': 'render'

    behaviors:
      ChangeModel:
        behaviorClass: ChangeModelBehavior


    onRender: ->
      @model.set('message', '')
      @$('.tour-booking-promo-help').tooltip(
        'title': 'Промо-код - специальный код, сопровождающий некоторые акции (может быть выслан на электронную почту или SMS) и позволяет получить скидку на наши услуги. Если у Вас нет промо-кода, оставьте поле пустым.'
      )


    _checkCode: ->
      if @model.isValid()
        @model.fetch(
          data:
            'code': @model.get('code')
            'sum': priceModel.get('value')
          'success': =>
            if @model.get('status') is 'success'
              channel.vent.trigger('after:sync:promoModel')
        )


    _showError: (model, error) ->
      @model.set('message', error)
      @render()


