define [
  'backbone'
  'components/pay/models/default'
], (Backbone, defaultModel) ->

  class MenuCollection extends Backbone.Collection

    model: Backbone.Model

    initialize: ->
      @add([
        {'id': 'card', 'name': 'Банковская карта'}
        {'id': 'cash', 'name': 'Наличные и банковский перевод'}
        {'id': 'clearing', 'name': 'Платежный перевод'}
        {'id': 'terminal', 'name': 'Терминалы и салоны связи'}
#        {'id': 'salon', 'name': 'Салоны связи'}
      ])

      if defaultModel.get('hasCreditAccess') then @add({'id': 'credit', 'name': 'Кошелек'})


  return new MenuCollection

