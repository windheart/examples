define [
  'components/core/events'
  'components/pay/models/default'
  'marionette'
  'components/pay/templates/main'
  'components/pay/views/main/menu'
  'components/pay/views/main/footer'

], (events, defaultModel, Marionette, MainTemplate, MenuView, FooterView) ->

  class MainLayout extends Marionette.Layout

    template: MainTemplate

    regions:
      'menu'   : '#pay-menu-region'
      'content': '#pay-content-region'
      'footer' : '#pay-footer-region'


    initialize: ->
      @listenTo(events, 'content:show', (view) => @content.show(view))
      @listenTo(events, 'app:toggleLock', (isLocked) => @$el.toggleLock(isLocked))



    onRender: ->
      if defaultModel.get('search') isnt 'meta'
        @$('#pay-menu-region').addClass('panel-heading')
        @menu.show(new MenuView)
      @footer.show(new FooterView)