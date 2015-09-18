define [
  'baseModel'
  'baseCollection'

], (BaseModel, BaseCollection) ->

  class WaypointModel extends BaseModel

    defaults:
      'id'            : null
      'cities'        : null
      'hotels'        : null
      'isSpa'         : false
      'currentHotelId': null
      'currentCityId' : null
      'currentMealId' : null


    initialize: (attrs) ->
      # TODO быдлокод - переделать
      @set('cities', new BaseCollection(_.toArray(attrs.cities)))
      @set('hotels', new BaseCollection(attrs.hotels))
      @set('rooms', new Backbone.Collection)


    hasSpaHotels: ->
      return @get('hotels').first().get('isSpa')


    hasFerries: ->
      return @get('hotels').first().get('isFerry')


    isEditable: ->
      if @hasFerries()
        waypointsWithFerries = @collection.filter((waypoint) -> return waypoint.hasFerries())

        return @get('hotels').length > 1 or (waypointsWithFerries.length > 1 and _.first(waypointsWithFerries).id is @id) or waypointsWithFerries.length is 1

      else
        waypointsWithoutFerries = @collection.filter((waypoint) -> return not waypoint.hasFerries())

        waypointsWithHotelSelection = @collection.filter((waypoint) -> return not waypoint.hasFerries() and waypoint.get('hotels').length > 1)
        waypointsWithoutHotelSelection = @collection.filter((waypoint) -> return not waypoint.hasFerries() and waypoint.get('hotels').length is 1)

        waypointsWithSpaHotels = @collection.filter((waypoint) -> return waypoint.hasSpaHotels())
        waypointsWithoutSpaHotels = @collection.filter((waypoint) -> return not waypoint.hasSpaHotels())

        if waypointsWithoutFerries.length is 1
          return true

        # Если есть курортные отели и можно их выбирать
        if @get('hotels').length > 1 and @hasSpaHotels()
          return true

        # Если есть выбор отеля и количество точек с выбором отеля не больше 2х
        if @get('hotels').length > 1 and waypointsWithHotelSelection.length < 3
          return true

        # Если есть точки с выбором маршрута и эта точка является первой из них
        if waypointsWithHotelSelection.length > 0 and _.first(waypointsWithHotelSelection).id is @id
          return true

        # Если нет точек с выбором отеля и точка является первой по маршруту
        if waypointsWithHotelSelection.length is 0 and _.first(waypointsWithoutFerries).id is @id
          return true

        if waypointsWithoutHotelSelection.length is 1 and waypointsWithHotelSelection.length is 1
          return true

        # Если несколько точек без выбора отеля, точка является первой из них и выбор отеля есть только в SPA-отеле
        if waypointsWithoutSpaHotels.length > 1 and _.first(waypointsWithoutSpaHotels).id is @id and waypointsWithHotelSelection.length is waypointsWithSpaHotels.length
          return true


        return false
