define [
  'marionette2'
  'components/tour/booking/channel'
  'pace'
  'components/tour/booking/models/order'
  'components/tour/booking/templates/default/order/error'
  'components/tour/booking/templates/default/order/default'
  'components/tour/booking/templates/default/order/success'

], (Marionette, channel, pace, OrderModel, OrderErrorTemplate, OrderDefaultTemplate, OrderSuccessTemplate) ->

  class OrderView extends Marionette.ItemView

    className: 'row'

    model: new OrderModel

    events:
      'click .tour-booking-order-make': '_make'
      'click .tour-booking-toggle-busseat': '_toggleBusseat'

    modelEvents:
      'change:showBusseat': 'render'


    initialize: ->
      @listenTo(channel.vent, 'validationResponse', @_setValidationResponse)

      # Команды
      channel.commands.setHandler('showSettlementError', =>
        @model.set('error', 'Пожалуйста, проверьте возраст туристов на доп.местах в номерах')
        @render()
      )


    getTemplate: ->
      if not @model.id
        if @model.get('error')
          return OrderErrorTemplate
        else
          return OrderDefaultTemplate
      else
        return OrderSuccessTemplate


    _isValid: ->
      @model.set('validationResponse', true)
      channel.vent.trigger('validationRequest')

      return @model.get('validationResponse')


    _setValidationResponse: (validationResponse) ->
      if not validationResponse then @model.set('validationResponse', false)


    _make: ->
      if @_isValid()
        pace.restart()
        @model.fetch().done( =>
          channel.vent.trigger('after:change:orderModel')
        )


    _toggleBusseat: (event) ->
      event.preventDefault()
      @model.set('showBusseat', not @model.get('showBusseat'))
