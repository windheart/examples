define [
  'backbone'
  'marionette'
  'components/core/events'
  'components/pay/models/clearing'
  'components/pay/models/clearing/form'
  'components/pay/views/main/clearing/form'
  'components/pay/templates/main/clearing'
  'components/pay/templates/main/clearing/form'

], (Backbone, Marionette, events, ClearingModel, FormModel, FormView, ClearingTemplate) ->

  class ClearingView extends Marionette.ItemView

    model: ClearingModel

    template: ClearingTemplate

    onRender: =>
      sbrf = new FormView(model: new FormModel(type:'sbrf'))
      bill = new FormView(model: new FormModel(type:'bill'))

      @$('.sbrf-container').append(sbrf.render().$el)
      @$('.bill-container').append(bill.render().$el)


