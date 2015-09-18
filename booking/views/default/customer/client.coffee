define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/customer/client'
  'components/tour/booking/models/customer'
  'components/tour/booking/behaviors/change-model'
  'jquery.validation'

], (Marionette, channel, CustomerClientTemplate, customerModel, ChangeModelBehavior) ->

  class CustomerClientView extends Marionette.ItemView

    tagName: 'form'

    className: 'col-xs-12'

    template: CustomerClientTemplate

    model: customerModel

    behaviors:
      ChangeModel:
        behaviorClass: ChangeModelBehavior


    initialize: ->
      @listenTo(channel.vent, 'validationRequest', @validationRequest)


    validationRequest: ->
      channel.vent.trigger('validationResponse', @$el.valid())


    validate: ->
      @$el.validate(
        highlight: (ctrl, errorClass, validClass) =>
          @$(ctrl).parents('.form-group')
          .removeClass(validClass)
          .removeClass('has-feedback')
          .addClass(errorClass)
          .find('.form-control-feedback')
          .remove()

        unhighlight: (ctrl, errorClass, validClass) =>
          formGroup = @$(ctrl).parents('.form-group')

          formGroup.removeClass(errorClass)
          .addClass('has-feedback')
          .addClass(validClass)
          .find('input')
          .after('<span class="glyphicon glyphicon-ok form-control-feedback"></span>')

          formGroup.find('.help-block').remove()

        errorElement: 'span'

        errorPlacement: (error, ctrl) ->
          if ctrl.next('.help-block').length
            return

          error.addClass('help-block').removeClass('has-error')
          ctrl.after(error)

        errorClass: 'has-error'

        validClass: 'has-success'

        rules:
          name:
            required: true
          email:
            required: true
            email: true
          phone:
            required: true

        messages:
          name:
            required: 'Не указано ФИО заказчика'
          email:
            required: 'Не указан email'
            email   : 'Неверный формат'
          phone:
            required: 'Не указан контактный телефон'
      )


    onRender: ->
      @validate()
      channel.vent.trigger('after:render:clientView', true)


    onDestroy: ->
      channel.vent.trigger('after:destroy:clientView', false)