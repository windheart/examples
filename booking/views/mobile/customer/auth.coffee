define [
  'components/tour/booking/views/default/customer/auth'
  'components/tour/booking/templates/mobile/customer/auth'

], (DefaultCustomerAuthView, CustomerAuthTemplate) ->

  class MobileCustomerAuthView extends DefaultCustomerAuthView

    tagName: 'form'

    className: 'tour-booking-customer-auth'

    template: CustomerAuthTemplate