define [
  'backbone'
  'components/core/channel'

], (Backbone, channel) ->

  class SearchModel extends Backbone.Model

    defaults:
      'id'              : 'best'
      'currentCatalogId': ''
      'catalogs'        : new Backbone.Collection(Data?.catalogs)
      'dateAfter'       : ''
      'dateUntil'       : ''
      'spo'             : new Backbone.Collection

    urlRoot: '/site/spo'


    initialize: ->
      channel.reqres.setHandler('spoSearchId', => return @get('id'))


    toJSON: ->
      data = super
      _.each(@attributes, (value, key) ->
        if value instanceof Backbone.Collection
          data[key] = value.toJSON()
      )
      data['validationError'] = @validationError or null

      return data


    toQuery: ->
      return @.pick('currentCatalogId', 'dateAfter', 'dateUntil')


    parse: (response) ->
      @get('spo').set(response)

      return