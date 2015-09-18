require [
  'marionette2'
  'components/core/layout2'
  'components/spo/models/search'
  'components/spo/views/desktop/search'
  'components/spo/views/desktop/result'

  'moment.ru'
  'components/core/utils/logger' # Logger JS ошибок
  'lib/scripts/jquery/fix/jsonp' # Отлов 404 ошибки для JSONP
  'components/core/fix/ie' # Некоторые багфиксы для IE

], (Marionette, layout, SearchModel, SearchView, ResultView) ->

  class SpoComponent extends Marionette.Application

    initialize: ->
      layout.addRegions(
        'spoSearch': '#spo-search-region'
        'spoResult': '#spo-result-region'
      )

      $('.spo-tab').click((event) ->
        ctrl = $(event.currentTarget)

        searchModel = new SearchModel(
          id: ctrl.data('id')
          currentCatalogId: $('#spo').data('currentCatalogId')
        )

        # Поисковая форма
        layout.getRegion('spoSearch').show(new SearchView(
          model: searchModel
        ))

        searchModel.fetch(
          dataType: 'json'
          data: searchModel.toQuery()
          success: ->
            # Результаты поиска
            layout.getRegion('spoResult').show(new ResultView(
              model: searchModel
              collection: searchModel.get('spo')
            ))
        )
      )

  return (new SpoComponent).start()
