define [
  'components/pay/component'
  'components/pay/models/default'
  'marionette'
  'components/pay/templates/main/footer'

], (component, coreModel, Marionette, FooterTemplate) ->

  class FooterView extends Marionette.ItemView

    template: FooterTemplate

    events:
      'click .pay-old': 'gotoOldVersion'


    gotoOldVersion: (event) ->
      event.preventDefault()
      component.logCardUserAction('openOldVersion-sberbankError')
      document.location.href = coreModel.get('oldUrl')
