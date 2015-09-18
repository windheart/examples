define [
  'components/tour/booking/channel'
  'baseModel'
  'baseCollection'
  'components/tour/booking/models/tour'
  'components/tour/booking/models/date'
  'components/tour/booking/collections/waypoint'
  'components/tour/booking/collections/extra-service'
  'components/tour/booking/collections/tourist'
  'components/tour/booking/models/package'

], (channel, BaseModel, BaseCollection, tourModel, dateModel, waypointCollection, extraServiceCollection, touristCollection, packageModel) ->

  class PriceModel extends BaseModel

    defaults:
      'id': 'booking-price'
      'value': 0
      'discount': 0
      'currency': ''
      'currencySymbol': ''
      'todayRate': 0
      'tomorrowRate': 0
      'package': []
      'paymentDates': []

    urlRoot: '/tour'


    hasGroupRate: ->
      hasGroupRate = false
      _.each(@get('package'), (service) ->
        if service.type is 3 and service.isGroupRate then hasGroupRate = true
      )

      return hasGroupRate



    getTotal: ->
      return @get('value') + @getExtra()


    getExtra: ->
      extraPriceValues = extraServiceCollection.map((extraService) ->
        return extraService.get('price').value * extraService.get('currentTouristQuantity')
      )

      return _.reduce(
        extraPriceValues
        (memo, num) -> return memo + num
        0
      )


    fetch: ->
      return super(
        'dataType': 'json'
        'data': @toQuery()
      )


    toQuery: ->
      # Для туров бз проживания (продаж отдельных услуг)
      if packageModel.get('services')
        services = _.map(packageModel.get('services'), (service) ->
          return _.pick(service, 'code', 'code1', 'code2', 'lineId')
        )

        return {
          'tour'    : _.pick(tourModel.toJSON(), 'id', 'currentVariantId')
          'date'    : dateModel.get('currentVariantId')
          'amount'  : touristCollection.length
          'services': services
        }

      # Для туров с проживанием в отелях или на паромах
      roomData = []
      # Получаем все точки маршрута, где указаны номера в отелях и отели экскурсионные, берем первую из них
      defaultHotelRooms    = []
      defaultHotelWaypoint = waypointCollection.find((waypoint) -> return waypoint.isEditable() and not waypoint.hasFerries())


      if defaultHotelWaypoint
        # Выбираем номера для отелей, которые будут использоваться по умолчанию в скрытых точках маршрута
        defaultHotelWaypoint.get('rooms').each((room) =>
          defaultHotelRoom = room.pick('categoryId', 'variantId', 'mainPlaces', 'extraPlaces', 'isPrimary')

          if room.get('extraVariantId')
            extraVariant = defaultHotelWaypoint.get('hotels').get(room.get('hotelId')).get('roomVariants').get(room.get('extraVariantId'))
            _.extend(defaultHotelRoom,
              'extraVariantAge':
                'min': extraVariant.get('ageMin')
                'max': extraVariant.get('ageMax')
            )
          defaultHotelRooms.push(defaultHotelRoom)
        )

      defaultFerryRooms    = []
      defaultFerryWaypoint = waypointCollection.find((waypoint) -> return waypoint.isEditable() and waypoint.hasFerries())

      if defaultFerryWaypoint
        # Выбираем номера для отелей, которые будут использоваться по умолчанию в скрытых точках маршрута
        defaultFerryWaypoint.get('rooms').each((room) =>
          defaultFerryRoom = room.pick('categoryId', 'variantId', 'mainPlaces', 'extraPlaces', 'isPrimary')
          if room.get('extraVariantId')
            extraVariant = defaultFerryWaypoint.get('rooms').get(room.get('extraVariantId'))
            _.extend(defaultFerryRoom,
              'extraVariantAge':
                'min': extraVariant.get('ageMin')
                'max': extraVariant.get('ageMax')
            )

          defaultFerryRooms.push(defaultFerryRoom)
        )

      waypointCollection.each((waypoint) =>
        # Для скрытых точек маршрута используем номера по умолчанию
        if not waypoint.isEditable()
          defaultRooms    = if waypoint.hasFerries() then defaultFerryRooms else defaultHotelRooms
          defaultWaypoint = if waypoint.hasFerries() then defaultFerryWaypoint else defaultHotelWaypoint
          defaultHotel    = defaultWaypoint.get('hotels').get(defaultWaypoint.get('currentHotelId'))

          _.each(defaultRooms, (defaultRoom) =>
            # Ищем отель такой же категории или первый в списке
            hotel = waypoint.get('hotels').findWhere({'category': defaultHotel.get('category')}) or waypoint.get('hotels').first()
            roomData.push(
              'waypointId'     : waypoint.id
              'hotelId'        : hotel.id or 0
              'categoryId'     : defaultRoom.categoryId
              'variantId'      : defaultRoom.variantId or 0
              'extraVariantAge': defaultRoom.extraVariantAge
              'mealId'         : defaultWaypoint.get('currentMealId') or 0
              'mainPlaces'     : defaultRoom.mainPlaces
              'extraPlaces'    : defaultRoom.extraPlaces
              'isPrimary'      : defaultRoom.isPrimary
            )
          )
        else
          waypoint.get('rooms').each((room) =>
            roomData.push(_.extend(room.pick('waypointId', 'hotelId', 'categoryId', 'variantId', 'extraVariantId', 'mainPlaces', 'extraPlaces', 'isPrimary'),
              'mealId': waypoint.get('currentMealId')
            ))
          )
      )

      return {
        'tour'  : _.pick(tourModel.toJSON(), 'id', 'currentVariantId')
        'date'  : dateModel.get('currentVariantId')
        'amount': touristCollection.length
        'rooms' : roomData
        'promo' : channel.reqres.request('promoCode')
        'currency': @get('currency')
      }


  return new PriceModel