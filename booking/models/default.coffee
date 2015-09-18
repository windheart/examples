define [
  'backbone'
  'baseModel'
  'components/tour/booking/models/tour'
  'components/tour/booking/models/date'
  'components/tour/booking/collections/waypoint'
  'components/tour/booking/collections/extra-service'
  'components/tour/booking/collections/extra-service-group'
  'components/tour/booking/collections/tourist'
  'components/tour/booking/models/customer'
  'components/tour/booking/models/package'
  'components/tour/booking/models/price'

], (Backbone, BaseModel, tourModel, dateModel, waypointCollection, extraServiceCollection, extraServiceGroupCollection, touristCollection, customerModel, packageModel, priceModel) ->

  class DefaultModel extends BaseModel

    defaults:
      'status': 'invalid'

    url: '/tour/booking-form'


    parse: (response) ->
      if response.status is 'error'
        return response

      tourModel.set(
        'variants': new Backbone.Collection(response.tourVariants)
        'currentVariantId': response.currentTourVariantId
      )

      # Временный хак, пока работает старая версия
      tourModel.unset('priceKey')

      dateModel.set(
        'duration': response.duration
        'variants': response.dates
        'currentVariantId': response.currentDate
      )

      packageModel.set(
        'items'   : response.tourPackage.items or null
        'services': response.tourPackage.services
      )

      extraServiceCollection.reset(response.extraServices)

      extraServiceGroupCollection.reset(response.extraServiceGroups)

      waypoints = _.map(response.waypoints, (waypoint) ->
        waypoint.hotels = _.map(_.toArray(waypoint.hotels), (hotel) ->
          return _.extend(hotel,
            category: parseInt(hotel.category)
          )
        )

        return waypoint
      )

      waypointCollection.reset(waypoints)

      return response


    toQuery: ->
      data = {
        'v'   : tourModel.get('currentVariantId')
        'd'   : dateModel.get('currentVariantId')
      }

      if priceModel.get('currency')
        data.currency = priceModel.get('currency')

      # Временный хак, пока работает старая версия
      if tourModel.get('priceKey')
        data.priceKey = tourModel.get('priceKey')
      else
        data.tour = tourModel.id

      _.each(['x', 'y', 'z', 'priceKey'], (param) ->
        if typeof tourModel.get(param) isnt 'undefined' then data[param] = tourModel.get(param)
      )

      return data


    fetch: ->
      return super(
        'dataType': 'json'
        'data': @toQuery()
      )


  return new DefaultModel