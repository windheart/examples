define [
    'marionette'
    'components/pay/controllers/default'

    # Вложенные роутеры.
    'components/pay/routers/card'
    'components/pay/routers/credit'

  ], (Marionette, defaultController) ->

  class DefaultRouter extends Marionette.AppRouter

    _routes: ['cash', 'clearing', 'salon', 'terminal']

    appRoutes:
      '': 'home'

    controller: defaultController


    initialize: ->
      _.each(@_routes, (name) =>
        @appRoute(name, name)
      )


  return new DefaultRouter