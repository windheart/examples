define [
  'marionette'
  'components/pay/templates/main/salon'

], (Marionette, SalonTemplate) ->

  class SalonView extends Marionette.ItemView

    template: SalonTemplate
