define [
  'backbone'
  'components/tour/parametric-search/collections/catalog'
  'components/tour/parametric-search/collections/partition'

], (Backbone, CatalogCollection, PartitionCollection) ->

  class SearchModel extends Backbone.Model

    url: '/site-api/prices/search'

    defaults:
      catalogs: new CatalogCollection(Data?.catalogs)
      partitions: new PartitionCollection
      currentCatalogId: null
      currentPartitionId: null
      dateMin: ''
      dateMax: ''
      adults: 2
      children: 0
      prices: new Backbone.Collection
      hasSpo: null
      currentPage: 1,
      pages: 1


    validate: (attrs) ->
      errors = {}
      if not attrs.dateMin then errors['dateMin'] = 'Не указана дата начала заездов'
      if not attrs.currentCatalogId then errors['currentCatalogId'] = 'Не выбрана страна или каталог'

      if not _.isEmpty(errors) then return errors


    toJSON: ->
      data = super
      _.each(@attributes, (value, key) ->
        if value instanceof Backbone.Collection
          data[key] = value.toJSON()
      )
      data['validationError'] = @validationError or null

      return data


    toQuery: ->
      queryMap = {
        'catalog': 'currentCatalogId'
        'partition': 'currentPartitionId'
        'start': 'dateMin'
        'end': 'dateMax'
        'adult': 'adults'
        'child': 'children'
        'hasActiveSpo': 'hasSpo'
        'page': 'currentPage'
      }

      queryData = {}
      _.each(queryMap, (attr, key) =>
        queryData[key] = @get(attr)
      )

      return queryData


