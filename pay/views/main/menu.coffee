define [
  'marionette'
  'components/pay/views/main/menu/item'
  'components/pay/collections/menu'

], (Marionette, ItemView, menuCollection) ->

  class MenuView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'pay-nav nav nav-pills'

    collection: menuCollection

    itemView: ItemView
