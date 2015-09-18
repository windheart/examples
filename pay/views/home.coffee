define [
  'backbone'
  'marionette'
  'components/pay/models/home'
  'components/pay/templates/home'

], (Backbone, Marionette, homeModel, HomeTemplate) ->

  class HomeView extends Marionette.ItemView

    model: homeModel

    template: HomeTemplate

    templateHelpers:
      getRate: (rate) ->
        if not rate
          return '&mdash;'

        return "#{rate} руб"

    ui:
      'variant': '.pay-variant'

    events:
      'click      @ui.variant': 'selectVariant'
      'mouseenter @ui.variant': 'toggleHighlight'
      'mouseleave @ui.variant': 'toggleHighlight'


    selectVariant: (event) ->
      Backbone.history.navigate(@$(event.currentTarget).data('variantId'), {'trigger': true})


    toggleHighlight: (event) ->
      @$(event.currentTarget).toggleClass('panel-info').toggleClass('panel-primary')