define [
  'backbone'

], (Backbone) ->

  class RoomModel extends Backbone.Model

    defaults:
      'waypointId'    : null
      'hotelId'       : null
      'categoryId'    : null
      'variantId'     : null
      'extraVariantId': null
      'totalPlaces'   : null
      'showExtraPlace': false
      'ageMin'        : null
      'ageMax'        : null