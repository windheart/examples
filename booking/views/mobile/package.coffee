define [
  'components/tour/booking/views/default/package'
  'components/tour/booking/templates/mobile/package'

], (DefaultPackageView, MobilePackageTemplate) ->

  class MobilePackageView extends DefaultPackageView

    className: 'list-group-item tour-booking-section'

    template: MobilePackageTemplate