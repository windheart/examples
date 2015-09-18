define [
  'components/tour/booking/views/default/customer/agency'
  'components/tour/booking/templates/mobile/customer/agency'

], (DefaultCustomerAgencyView, MobileCustomerAgencyTemplate) ->

  class MobileCustomerAgencyView extends DefaultCustomerAgencyView

    className: ''

    template: MobileCustomerAgencyTemplate