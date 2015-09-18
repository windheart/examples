define [
  'marionette2'
  'backbone'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/waypoints/item/room'
  'components/tour/booking/collections/waypoint'
  'components/tour/booking/helpers/template/waypoint'
  'components/core/utils/html'

], (Marionette, Backbone, channel, RoomTemplate, waypointCollection, waypointTemplateHelper, htmlUtil) ->

  class RoomView extends Marionette.ItemView

    className: 'row tour-booking-room'

    template: RoomTemplate

    templateHelpers: ->
      return _.extend(waypointTemplateHelper,
        htmlUtil: htmlUtil
      )

    events:
      'click .tour-booking-room-remove a'          : '_remove'
      'change .form-control'                       : '_change'
      'click .tour-booking-room-toggle-extra-place': '_toggleExtraPlace'

    modelEvents:
      'change:categoryId'    : '_changeCategoryId'
      'change:variantId'     : '_changeVariantId'


    serializeData: ->
      hotel         = @_getHotel()
      variants      = @_getVariants()
      extraVariants = @_getExtraVariants()

      return _.extend(@model.toJSON(),
        'categories'      : hotel.get('roomCategories').toJSON()
        'variants'        : variants.toJSON()
        'extraVariants'   : extraVariants.toJSON()
        'hasExtraVariants': !!extraVariants.length
        'isRemovable'     : @model.collection.length > 1
        'isSpa'           : hotel.get('isSpa')
      )


    _change: (event) ->
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), parseInt(ctrl.val()))
      channel.vent.trigger('after:change:waypointCollection')


    _changeCategoryId: ->
      variant = @_getHotel().get('roomVariants').findWhere({'categoryId': @model.get('categoryId')})
      @model.set('variantId', variant.id)
      @render()


    _changeVariantId: ->
      variant = @_getHotel().get('roomVariants').get(@model.get('variantId'))
      @model.set(
        'totalPlaces'   : variant.get('totalPlaces')
        'mainPlaces'    : variant.get('mainPlaces')
        'extraPlaces'   : variant.get('extraPlaces')
        'isPrimary'     : variant.get('isPrimary')
        'showExtraPlace': false
        'extraVariantId': null
      )
      @render()


    _toggleExtraPlace: ->
      showExtraPlace = not @model.get('showExtraPlace')
      @model.set(
        'showExtraPlace': showExtraPlace
        'extraVariantId': if showExtraPlace then @_getExtraVariants().first().id else null
      )
      @render()
      channel.vent.trigger('after:change:waypointCollection')


    _remove: (event) ->
      event.preventDefault()
      @model.destroy()
      channel.vent.trigger('after:change:waypointCollection')


    _getHotel: ->
      return waypointCollection.get(@model.get('waypointId')).get('hotels').get(@model.get('hotelId'))


    _getCurrentVariant: ->
      @_getHotel().get('roomVariants').get(@model.get('variantId'))


    _getVariants: ->
      return new Backbone.Collection(@_getHotel().get('roomVariants').where(
        'categoryId': @model.get('categoryId')
        'isPrimary': true
      ),
        'comparator': 'mainPlaces'
      )


    _getExtraVariants: ->
      return new Backbone.Collection(@_getHotel().get('roomVariants').where(
        'categoryId': @model.get('categoryId')
        'mainPlaces': @_getCurrentVariant().get('mainPlaces')
        'isPrimary': false
      ))