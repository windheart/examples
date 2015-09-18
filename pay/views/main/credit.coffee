define [
  'components/core/env'
  'components/core/events'
  'marionette'
  'components/pay/models/credit'
  'components/pay/views/main/sum'
  'components/pay/templates/main/credit'
  'bootstrap/alert'

], (Env, events, Marionette, creditModel, SumView, CreditTemplate) ->

  class CreditView extends Marionette.Layout

    className: 'pay-credit-view'

    model: creditModel

    template: CreditTemplate

    ui:
      'make': '.pay-credit-gate'
      'attr': '.pay-credit-attr'

    events:
      'click  @ui.make': 'make'
      'change @ui.attr': 'change'

    modelEvents:
      'change:sum': 'updateSumText'

    regions:
      'sumText': '#pay-sum-total-region'


    change: (event) ->
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), ctrl.val())

      if ctrl.prop('name') is 'originalSum' or ctrl.prop('name') is 'currentCurrencyId'
        @model.set('sum', parseFloat(@model.get('originalSum') * @model.get('currencies').get(@model.get('currentCurrencyId')).get('rate')))


    # Преобразовываем введенную сумму платежа в текст.
    updateSumText: ->
      @sumText.show(new SumView(
        'model'   : new Backbone.Model(
          'sum': @model.get('sum')
        )
      ))


    onDomRefresh: ->
      @updateSumText()
      @_setTooltip()


    _setTooltip: ->
      Env.request('tooltip', @$('.pay-tooltip'))
