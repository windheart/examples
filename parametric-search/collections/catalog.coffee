define [
  'backbone'

], (Backbone) ->

  class CatalogCollection extends Backbone.Collection

    url: '/site-api/catalogs/search'
