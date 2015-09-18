define [
  'components/tour/booking/channel'
  'components/tour/booking/views/default'
  'components/tour/booking/views/mobile/tour'
  'components/tour/booking/views/mobile/date'
  'components/tour/booking/views/mobile/extra-service-groups'
  'components/tour/booking/views/mobile/tourists'
  'components/tour/booking/views/mobile/customer'
  'components/tour/booking/views/mobile/price'
  'components/tour/booking/views/mobile/order'
  'components/tour/booking/views/mobile/waypoints'
  'components/tour/booking/views/mobile/package'
  'components/tour/booking/views/mobile/promo'
  'components/tour/booking/views/default/error'
  'components/tour/booking/collections/waypoint'
  'components/tour/booking/collections/extra-service'

], (channel, DefaultView, TourView, DateView, ExtraServiceGroupsView, TouristsView, CustomerView, PriceView, OrderView, WaypointsView, PackageView, PromoView, ErrorView, waypointCollection, extraServiceCollection) ->

  class MobileView extends DefaultView

    _showRegions: ->
      _.each(@regions, (container, name) =>
        if @getRegion(name).currentView then @getRegion(name).reset()
      )

      if @model.get('status') is 'error'
        @error.show(new ErrorView)
      else
        if not channel.reqres.request('orderId')
          @tour.show(new TourView)
          @date.show(new DateView)

          if waypointCollection.length
            @waypoints.show(new WaypointsView)

          @package.show(new PackageView)

          if extraServiceCollection.length
            @extraServiceGroups.show(new ExtraServiceGroupsView)

          @promo.show(new PromoView)
          @price.show(new PriceView)
          @customer.show(new CustomerView)
          @tourists.show(new TouristsView)

        @order.show(new OrderView)
