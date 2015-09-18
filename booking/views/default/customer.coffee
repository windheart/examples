define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/customer'
  'components/tour/booking/models/customer'

  'components/tour/booking/views/default/customer/agency'
  'components/tour/booking/views/default/customer/auth'
  'components/tour/booking/views/default/customer/client'


], (Marionette, channel, CustomerCompositeTemplate, customerModel, CustomerAgencyView, CustomerAuthView, CustomerClientView) ->

  class CustomerCompositeView extends Marionette.LayoutView

    className: 'row tour-booking-section tour-booking-block'

    template: CustomerCompositeTemplate

    templateHelpers: ->
      return {
        isSelected: (type) =>
          if type is @model.get('type') then return 'checked="checked"'
      }


    model: customerModel

    events:
      'change input, textarea': 'changeModel'

    modelEvents:
      'change:type change:id': 'render'

    regions:
      'type': '.tour-booking-customer-type-region'


    initialize: ->
      @listenTo(channel.vent, 'validationRequest', @validationRequest)
      if @model.get('type') is 'client'
        @model.fetch().always( =>
          @model.set(
            'status' : ''
            'message': ''
          )
          @render()
        )


    validationRequest: ->
      channel.vent.trigger('validationResponse', @model.get('type') isnt 'auth')


    changeModel: (event) ->
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), ctrl.val() or ctrl.data('value'))


    serializeData: ->
      return _.extend(@model.toJSON(),
        hasTypeSelect: _.contains(['client', 'auth'], @model.get('type'))
      )


    onRender: ->
      switch @model.get('type')
        when 'auth'   then View = CustomerAuthView
        when 'client' then View = CustomerClientView
        else View = CustomerAgencyView

      @type.show(new View)


