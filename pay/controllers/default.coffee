define [
  'marionette'
  'components/core/events'
  'components/core/layout'
  'components/pay/views/home'
  'components/pay/views/main'
  'components/pay/views/main/cash'
  'components/pay/views/main/clearing'
  'components/pay/views/main/salon'
  'components/pay/views/main/terminal'

], (Marionette, events, layout, HomeView, MainLayout, CashView, ClearingView, SalonView, TerminalView) ->

  class DefaultController extends Marionette.Controller

    _map:
      'cash'    : CashView
      'clearing': ClearingView
      'salon'   : SalonView
      'terminal': TerminalView


    initialize: ->
      # Генерируем методы, связанные с роутером.
      _.each(@_map, (View, route) =>
        @[route] = =>
          return @triggerRoute(new View, route)
      )
      @listenTo(events, 'triggerRoute', @triggerRoute)
      layout.addRegion('pay', '#pay')


    home: ->
      layout.pay.show(new HomeView)


    triggerRoute: (view, route) ->
      if layout.pay.currentView not instanceof MainLayout then layout.pay.show(new MainLayout)

      events.trigger('content:show', view)
      events.trigger('menu:selectItem', route)


  return new DefaultController