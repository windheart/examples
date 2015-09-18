define [
  'backbone'

], (Backbone) ->

  class DateModel extends Backbone.Model

    defaults:
      'id': null
      'duration': null
      'variants': []
      'currentVariantId': null


  return new DateModel