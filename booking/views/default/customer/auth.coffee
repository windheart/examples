define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/customer/auth'
  'components/tour/booking/models/customer'
  'components/tour/booking/behaviors/change-model'
  'jquery.validation'

], (Marionette, channel, CustomerAuthTemplate, customerModel, ChangeModelBehavior) ->

  class CustomerAuthView extends Marionette.ItemView

    tagName: 'form'

    className: 'col-xs-12 form-horizontal tour-booking-customer-auth'

    template: CustomerAuthTemplate

    templateHelpers:
      hasError: (status) ->
        return status is 'error'

    model: customerModel

    events:
      'click .tour-booking-auth-login': 'login'
      'click .tour-booking-auth-recover-password': 'recoverPassword'

    modelEvents:
      'change:status': 'showError'

    behaviors:
      ChangeModel:
        behaviorClass: ChangeModelBehavior


    initialize: ->
      @listenTo(channel.vent, 'validationRequest', @validationRequest)


    validationRequest: ->
      channel.vent.trigger('validationResponse', @$el.valid())


    login: (event) ->
      event.preventDefault()
      if @$el.valid()
        @model.set('status', '').fetch().done( ->
          channel.vent.trigger('logged:customer')
        )


    recoverPassword: (event) ->
      event.preventDefault()
      channel.vent.trigger('show:recoverPasswordView')


    showError: ->
      if @model.get('status') is 'error' then @render()



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
          login:
            required: true
          password:
            required: true

        messages:
          login:
            required: 'Не указан логин'
          password:
            required: 'Не указан пароль'
      )


    onRender: ->
      @validate()