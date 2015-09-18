define [
  'components/tour/booking/views/default/promo'
  'components/tour/booking/templates/mobile/promo'

], (DefaultPromoView, MobilePromoTemplate) ->

  class MobilePromoView extends DefaultPromoView

    className: 'list-group-item tour-booking-section'

    template: MobilePromoTemplate


