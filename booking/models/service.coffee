define [
  'baseModel'

], (BaseModel) ->

  class ServiceModel extends BaseModel

    defaults:
      currentTouristQuantity: 0
      isActive: false


    isAdditional: ->
      return @get('groupId') is 0
