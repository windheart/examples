define [
  'marionette2'
  'backbone'
  'baseModel'
  'pace'
  'components/tour/booking/channel'
  'components/tour/booking/models/default'
  'components/tour/booking/views/default/tour'
  'components/tour/booking/views/default/date'
  'components/tour/booking/views/default/extra-service-groups'
  'components/tour/booking/views/default/tourists'
  'components/tour/booking/views/default/customer'
  'components/tour/booking/views/default/price'
  'components/tour/booking/views/default/price/list'
  'components/tour/booking/views/default/customer/auth/recover-password'
  'components/tour/booking/collections/extra-service'
  'components/tour/booking/views/default/order'
  'components/tour/booking/views/default/waypoints'
  'components/tour/booking/collections/waypoint'
  'components/tour/booking/views/default/package'
  'components/tour/booking/views/default/promo'
  'components/tour/booking/views/default/error'
  'components/tour/booking/views/default/modal'

  'bootstrap.modal'

], (Marionette, Backbone, BaseModel, pace, channel, defaultModel, TourView, DateView, ExtraServiceGroupCollectionView, TouristCompositeView, CustomerView, PriceView, PriceListView, RecoverPasswordView, extraServiceCollection, OrderView, WaypointsView, waypointCollection, PackageView, PromoView, ErrorView, ModalView) ->

  class DefaultView extends Marionette.LayoutView

    el: '.tour-booking-layout'

    model: defaultModel

    regions:
      'order'             : '#tour-booking-order-region'
      'tour'              : '#tour-booking-tour-region'
      'date'              : '#tour-booking-date-region'
      'waypoints'         : '#tour-booking-waypoints-region'
      'package'           : '#tour-booking-package-region'
      'touristGroups'     : '#tour-booking-tourist-groups-region'
      'extraServiceGroups': '#tour-booking-extras-region'
      'promo'             : '#tour-booking-promo-region'
      'price'             : '#tour-booking-price-region'
      'tourists'          : '#tour-booking-tourists-region'
      'customer'          : '#tour-booking-customer-region'
      'modal'             : '#tour-booking-modal-region'
      'error'             : '#tour-booking-error-region'


    initialize: ->
      @listenTo(channel.vent, 'change:tourModel change:dateModel', @getFilters)
      @listenTo(channel.vent, 'before:show:priceListView', @showPriceList)
      @listenTo(channel.vent, 'show:recoverPasswordView', @showRecoverPassword)
      @listenTo(channel.vent, 'after:click:techSupportNotifyLink', @_showTechSupportForm)
      @listenTo(channel.vent, 'after:click:oldBookingLink', @_followOldUrl)
      @listenTo(channel.vent, 'after:change:orderModel', @_showRegions)
      @listenTo(channel.vent, 'after:render:clientView after:destroy:clientView', @_togglePromo)

      @listenTo(channel.vent, 'show:modal', @showModal)
      @listenTo(channel.vent, 'close:modal', @closeModal)

      @listenTo(channel.vent, 'before:show:modal', @_prepareModal)

      @_showRegions()


    showPriceList: (params = {}) ->
      @modal.show(new PriceListView({model: new Backbone.Model(params)}))


    showRecoverPassword: ->
      @modal.show(new RecoverPasswordView)


    showModal: ->
      @$('#tour-booking-modal-region').modal('show')


    closeModal: ->
      @$('#tour-booking-modal-region').modal('hide')


    _prepareModal: (params) ->
      @modal.show(new ModalView(params))


    getFilters: ->
      pace.restart()
      @model.fetch().done( => @_showRegions())


    _togglePromo: (isVisible) ->
      if isVisible then @getRegion('promo').show(new PromoView) else @getRegion('promo').reset()


    _showRegions: ->
      _.each(@regions, (container, name) =>
        if @getRegion(name).currentView then @getRegion(name).reset()
      )

      if @model.get('status') is 'error'
        @error.show(new ErrorView(
          model: @model
        ))
      else
        if not channel.reqres.request('orderId')
          @tour.show(new TourView)
          @date.show(new DateView)

          if waypointCollection.length
            @waypoints.show(new WaypointsView)

          @package.show(new PackageView)

          if extraServiceCollection.length
            @extraServiceGroups.show(new ExtraServiceGroupCollectionView)

          @promo.show(new PromoView)
          @price.show(new PriceView)
          @customer.show(new CustomerView)
          @tourists.show(new TouristCompositeView)

        @order.show(new OrderView)


    _showTechSupportForm: ->
      @modal.show(new TechSupportFormView)


    _followOldUrl: ->
      document.location.href = @$('#tour-booking-old-url').prop('href')
