define [
  'backbone'
  'marionette'
  'components/core/events'
  'components/pay/views/main/credit'
  'components/pay/views/main/credit/success'
  'components/pay/models/credit'
  'components/common/views/status'
  'components/common/models/status'

], (Backbone, Marionette, events, CreditView, CreditSuccessView, creditModel, StatusView, StatusModel) ->

  class CreditController extends Marionette.Controller

    default: ->
      route = 'credit'

      if creditModel.get('status') is 'ready'
        return events.trigger('triggerRoute', new CreditView, route)

      events.trigger('triggerRoute', new StatusView, route)
      creditModel.resetProcessingData()
      .fetch()
      .always( (response) ->
        if response.errorMessage
          return events.trigger('content:show', new StatusView(
            'model': new StatusModel(
              'category': 'danger'
              'message' : response.errorMessage
            )
          ))

        creditModel.set('status', 'ready')
        events.trigger('content:show', new CreditView)
      )


    process: ->
      if creditModel.get('status') is 'pending'
        return Backbone.history.navigate('credit', {'trigger': true})

      events.trigger('content:show', new StatusView)

      dfdProcess = Marionette.$.Deferred()
      creditModel.resetProcessingData()
      .set('id', 'make-credit')
      .fetch()
      .always( ->
        if creditModel.get('errorMessage') or not creditModel.get('isSuccess')
          if not creditModel.get('errorMessage') then creditModel.set('errorMessage', 'Системная ошибка')
          events.trigger('content:show', new CreditView)
          Backbone.history.navigate('credit', {'replace': true})
        else
          dfdProcess.resolve()
        )

      dfdProcess.done( ->
        creditModel.set('id', 'info')
        .fetch()
        .always( ->
          events.trigger('content:show', new CreditSuccessView)
          Backbone.history.navigate('credit', {'replace': true})
        )
      )


  return new CreditController