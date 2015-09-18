define [
  'components/tour/booking/views/default/price'
  'components/tour/booking/templates/mobile/price'

], (DefaultPriceView, MobilePriceTemplate) ->

  class MobilePriceView extends DefaultPriceView

    className: 'list-group-item tour-booking-section bg-info'

    template: MobilePriceTemplate
