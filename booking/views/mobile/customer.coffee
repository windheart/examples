define [
  'components/tour/booking/views/default/customer'
  'components/tour/booking/templates/mobile/customer'

  'components/tour/booking/views/mobile/customer/client'
  'components/tour/booking/views/mobile/customer/agency'
  'components/tour/booking/views/mobile/customer/auth'

], (DefaultCustomerView, CustomerTemplate, CustomerClientView, CustomerAgencyView, CustomerAuthView) ->

  class MobileCustomerView extends DefaultCustomerView

    className: 'list-group-item tour-booking-section'

    template: CustomerTemplate

    events:
      'change input, textarea': 'changeModel'
      'click .btn': 'changeModel'


    templateHelpers: ->
      return {
        isSelected: (type) =>
          return if type is @model.get('type') then 'btn-primary active' else 'btn-default'
      }


    onRender: ->
      switch @model.get('type')
        when 'auth'   then View = CustomerAuthView
        when 'client' then View = CustomerClientView
        else View = CustomerAgencyView

      @type.show(new View)
