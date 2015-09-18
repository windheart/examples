define [
  'marionette'
  'components/pay/models/cash'
  'components/pay/templates/main/cash'

], (Marionette, cashModel, CashTemplate) ->

  class CashView extends Marionette.ItemView

    model: cashModel

    template: CashTemplate


    onDomRefresh: ->
      require(['async!https://maps.google.com/maps/api/js?sensor=false!callback'], =>
        map = new google.maps.Map(document.getElementById('pay-map'),
          mapTypeId: google.maps.MapTypeId.ROADMAP
          center   : new google.maps.LatLng(@model.get('y'), @model.get('x'))
          zoom     : @model.get('zoom')
        )

        marker = new google.maps.Marker(
          position : new google.maps.LatLng(@model.get('y'), @model.get('x'))
          map      : map
        )
      )

      return


  return CashView