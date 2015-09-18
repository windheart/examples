define [
  'marionette2'
  'backbone'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/waypoints/item'
  'components/tour/booking/views/default/waypoints/item/room'
  'components/tour/booking/collections/tourist'
  'components/core/utils/text'
  'components/core/utils/text/geo'
  'components/core/utils/html'
  'components/tour/booking/helpers/template/waypoint'

], (Marionette, Backbone, channel, WaypointItemTemplate, RoomView, touristCollection, textUtil, textGeoUtil, htmlUtil, waypointTemplateHelper) ->

  class WaypointItemView extends Marionette.CompositeView

    tagName: 'form'

    className: 'row tour-booking-waypoint'

    template: WaypointItemTemplate

    childView: RoomView

    childViewContainer: '.tour-booking-room-collection'

    events:
      'click .tour-booking-hotel-add-room a'     : '_addRoom'
      'change .tour-booking-hotel .form-control' : '_change'


    modelEvents: ->
      'change:currentCityId' : '_changeCurrentCityId'
      'change:currentHotelId': '_changeCurrentHotelId'


    templateHelpers: ->
      return _.extend(waypointTemplateHelper,
        htmlUtil: htmlUtil

        currentCityName: =>
          return textGeoUtil.getCityNameCaseForm(@model.get('cities').get(@model.get('currentCityId')).get('name'), 'pr', true)

        labels: (name) =>
          labels = {
            'hotel'  : 'Отель'
            'rooms'  : 'Номера в отеле'
            'addRoom': 'Добавить номер'
          }

          if @model.get('hotels').get(@model.get('currentHotelId')).get('isFerry')
            labels = {
              'hotel'  : 'Паром'
              'rooms'  : 'Каюты на пароме'
              'addRoom': 'Добавить каюту'
            }

          return labels[name]

        groupHotelsByCategory: =>
          groups = _.uniq(@model.get('hotels').pluck('category')).sort()
          str = ''
          _.each(groups, (group) =>
            str += "<optgroup label=\"Категория #{group}*\">"
            hotels = new Backbone.Collection(@model.get('hotels').where({category: group}),
              comparator: 'name'
            )
            hotels.each((hotel) =>
              selected = htmlUtil.isSelected(hotel.id, @model.get('currentHotelId'))
              str += "<option #{selected} value=\"#{hotel.id}\">#{textUtil.ucwords(hotel.get('name')).replace(/\d+/g, '')}</option>"
            )
          )
          str += '</optgroup>'

          return str
      )


    initialize: ->
      @collection = @model.get('rooms')
      @listenTo(channel.vent, 'after:initialize:priceView', @_addRoom)
      @listenTo(channel.vent, 'validationRequest', @validationRequest)


    serializeData: ->
      hotel = @_getCurrentHotel()
      editableWaypointItems = @model.collection.filter((waypointItem) -> return waypointItem.isEditable())

      return _.extend(@model.toJSON(),
        'hotels'  : _.map(@model.get('hotels').where({'cityId': hotel.get('cityId')}), (model) -> return model.toJSON())
        'meals'   : hotel.get('meals').toJSON()
        'isSpa'   : hotel.get('isSpa')
        'isFerry' : hotel.get('isFerry')
        'showCitySelector': @model.get('cities').length > 1
        'showCityName'    : @model.collection.length is 1 or editableWaypointItems.length > 1
      )


    validationRequest: ->
      channel.vent.trigger('validationResponse', @_validate())


    # Проверяем соответствие возрастов туристов и выбранных номеров
    # Если количество расселенных не совпадает с общим - выдаем ошибку
    _validate: ->
      hotel = @_getCurrentHotel()
      settledTourists = []

      # Пробегаемся по всем номерам, пробуем расселить туристов
      @collection.each((room) =>
        mainPlaces = hotel.get('roomVariants').get(room.get('variantId')).get('mainPlaces')
        touristCollection
          .sort()
          .each((tourist) =>
            if _.contains(settledTourists, tourist.cid) or not mainPlaces then return false
            settledTourists.push(tourist.cid)
            --mainPlaces
          )

        extraRoomVariant = hotel.get('roomVariants').get(room.get('extraVariantId'))
        if extraRoomVariant
          extraPlaces = 1
          touristCollection
            .sort()
            .each((tourist) =>
              if _.contains(settledTourists, tourist.cid) or not extraPlaces then return false
              if tourist.getAge() < extraRoomVariant.get('ageMax') or not extraRoomVariant.get('ageMax')
                settledTourists.push(tourist.cid)
                --extraPlaces
            )
      )

      if settledTourists.length isnt touristCollection.length
        channel.commands.execute('showSettlementError');

      return settledTourists.length is touristCollection.length


    # Добавляем еще один номер из выбранного отеля для проживания в точке маршрута
    _addRoom: (event) ->
      event?.preventDefault()

      hotel = @_getCurrentHotel()
      roomVariant = hotel.get('roomVariants').get(hotel.get('currentRoomVariantId')) or hotel.get('roomVariants').findWhere({'isPrimary': true})

      # Если выбранный по умолчанию вариант - доп.место, подбираем для него основное
      extraVariantId = null
      if not roomVariant.get('isPrimary')
        extraVariantId = roomVariant.id
        _roomVariant   = hotel.get('roomVariants').findWhere(
          'categoryId': roomVariant.get('categoryId')
          'mainPlaces': roomVariant.get('mainPlaces')
          'isPrimary' : true
        )

        # Оказывается, бывает, что в ценовой таблице паромов есть указание на цену, но бронирование невозможно :)
        # В этом случае игнорируем, что клиент выбрал номер с допместом, а подставляем вместо него основной на 3 места
        if not _roomVariant
          extraVariantId = null
          _roomVariant    = hotel.get('roomVariants').findWhere(
            'categoryId': roomVariant.get('categoryId')
            'mainPlaces': 3
            'isPrimary' : true
          )

        # Если находим хоть какой-то вариант основного размещения - используем, иначе берем первый попавшийся
        roomVariant = _roomVariant or hotel.get('roomVariants').findWhere({'isPrimary': true})

      @collection.add(
        'waypointId'    : hotel.get('waypointId')
        'hotelId'       : hotel.id
        'categoryId'    : roomVariant.get('categoryId')
        'variantId'     : roomVariant.id
        'extraVariantId': extraVariantId
        'totalPlaces'   : roomVariant.get('totalPlaces')
        'showExtraPlace': !!extraVariantId
        'mainPlaces'    : roomVariant.get('mainPlaces')
        'extraPlaces'   : roomVariant.get('extraPlaces')
        'isPrimary'     : roomVariant.get('isPrimary')
      )

      if event
        channel.vent.trigger('after:change:waypointCollection')


    # Изменяем одно из свойств модели
    _change: (event) ->
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), parseInt(ctrl.val()))
      channel.vent.trigger('after:change:waypointCollection')


    # Если меняется город в точке маршрута
    _changeCurrentCityId: ->
      @model.set('currentHotelId', parseInt(@model.get('hotels').findWhere({'cityId': @model.get('currentCityId')}).id))


    # Если меняется отель в точке маршрута
    _changeCurrentHotelId: ->
      @model.set('currentMealId', parseInt(@_getCurrentHotel().get('meals').first().id), {'silent': true})
      @collection.reset()
      @_addRoom()
      @render()


    # Инкапсулируем получения текущего города в отдельную функцию для удобства
    _getCurrentCity: ->
      return @model.get('cities').get(@model.get('currentCityId'))


    # Инкапсулируем получения текущего отеля в отдельную функцию для удобства
    _getCurrentHotel: ->
      return @model.get('hotels').get(@model.get('currentHotelId'))
