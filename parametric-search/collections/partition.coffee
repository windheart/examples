define [
  'backbone'

], (Backbone) ->

  class PartitionCollection extends Backbone.Collection

    url: '/site-api/partitions/search'