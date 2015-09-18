require [
  'marionette2'
  'components/core/layout2'
  'components/tour/parametric-search/views/desktop/form'

  'moment.ru'
  'components/core/utils/logger' # Logger JS ошибок
  'lib/scripts/jquery/fix/jsonp' # Отлов 404 ошибки для JSONP
  'components/core/fix/ie' # Некоторые багфиксы для IE

], (Marionette, layout, FormView) ->

  class TourParametricSearchComponent extends Marionette.Application

    initialize: ->
      layout.addRegions(
        'parametricSearchForm': '#tour-parametric-search-form-region'
        'parametricSearchResult': '#tour-parametric-search-result-region'
      )
      layout.getRegion('parametricSearchForm').show(new FormView)


  return (new TourParametricSearchComponent).start()
