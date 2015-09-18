define [
  'components/core/events'
  'marionette'
  'components/pay/templates/main/menu/item'

], (events, Marionette, ItemTemplate) ->

  class ItemView extends Marionette.ItemView

    tagName: 'li'

    template: ItemTemplate


    initialize: ->
      events.on('menu:selectItem', (itemId) =>
        @$el.toggleClass('active', @model.id is itemId)
      )


    onClose: ->
      events.off('menu:selectItem')


  return ItemView