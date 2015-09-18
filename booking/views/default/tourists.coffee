define [
  'marionette2'
  'backbone'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/tourists'
  'components/tour/booking/collections/tourist'
  'components/tour/booking/views/default/tourists/item'
  'components/tour/booking/collections/waypoint'
  'components/tour/booking/models/package'
  'components/tour/booking/models/default'

], (Marionette, Backbone, channel, TouristsTemplate, touristCollection, TouristItemView, waypointCollection, packageModel, defaultModel) ->

  class TouristsView extends Marionette.CompositeView

    className: 'row tour-booking-section tour-booking-block'

    template: TouristsTemplate

    collection: touristCollection

    childView: TouristItemView

    childViewContainer: '#tour-booking-tourist-collection'


    events:
      'click .tour-booking-fill-tourists-data': '_fillData'


    initialize: ->
      @_prepareTourists()
      @listenTo(channel.vent, 'after:change:waypointCollection', @_prepareTourists)


    serializeData: ->
      return {
        'isLocal': defaultModel.get('isLocal')
      }


    _prepareTourists: ->
      totalTourists = 0

      if packageModel.get('services')
        totalTourists = 1

      if waypointCollection.length
        waypointCollection.each((waypoint) ->
          waypointTourists = 0
          waypoint.get('rooms').each((room) ->
            waypointTourists += room.get('totalPlaces')
            if room.get('extraVariantId')
              ++waypointTourists
          )
          if waypointTourists > totalTourists
            totalTourists = waypointTourists
        )

      if totalTourists > touristCollection.length
        _.times(totalTourists - touristCollection.length, -> touristCollection.add({}))
      else
        _.times(touristCollection.length - totalTourists, -> touristCollection.last().destroy())

      channel.vent.trigger('after:prepare:touristCollection')


    _fillData: (event) ->
      event.preventDefault()
      @collection.each((tourist, index) =>
        counter = index + 1
        tourist.set(
          'sex'              : 0
          'firstNameRu'      : "Tourist#{counter}"
          'lastNameRu'       : "Tourist#{counter}"
          'firstName'        : "Tourist#{counter}"
          'lastName'         : "Tourist#{counter}"
          'birthday'         : "01.01.197#{counter}"
          'passportSeries'   : "#{counter}#{counter}"
          'passportNumber'   : "#{counter}#{counter}"
          'passportValidTill': '01.01.1920'
        )
      )

      @render()

