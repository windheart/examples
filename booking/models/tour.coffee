define [
  'backbone'
  'baseModel'

], (Backbone, BaseModel) ->

  class TourModel extends BaseModel

    defaults:
      'id': null
      'variants': new Backbone.Collection
      'currentVariantId': null
      'package': ''


  return new TourModel