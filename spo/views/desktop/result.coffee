define [
  'marionette2'
  'components/spo/views/desktop/result/item'
  'components/spo/views/desktop/result/empty'

], (Marionette, ItemView, EmptyView) ->

  class ResultView extends Marionette.CollectionView

    className: 'spo-item-collection'

    childView: ItemView

    emptyView: EmptyView

    modelEvents:
      'change:currentCatalogId change:dateUntil change:dateAfter': '_syncModel'


    _syncModel: ->
      @model.fetch(
        dataType: 'json'
        data: @model.toQuery()
      )
