define [
  'components/tour/booking/views/default/customer/client'
  'components/tour/booking/templates/mobile/customer/client'

], (DefaultCustomerClientView, MobileCustomerClientTemplate) ->

  class MobileCustomerClientView extends DefaultCustomerClientView

    className: ''

    template: MobileCustomerClientTemplate