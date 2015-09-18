define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/customer/agency'
  'components/tour/booking/models/customer'
  'components/tour/booking/collections/customer/agency'
  'components/tour/booking/behaviors/change-model'
  'jquery.validation'
  'selectize'

], (Marionette, channel, CustomerAgencyTemplate, customerModel, customerAgencyCollection, ChangeModelBehavior) ->

  class CustomerAgencyView extends Marionette.ItemView

    tagName: 'form'

    className: 'col-xs-12'

    template: CustomerAgencyTemplate

    model: customerModel

    ui:
      'name': '.tour-booking-agency-name'

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

          if formGroup.find('.form-control-feedback').length
            return false

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
          email:
            required: true
            email: true
          phone:
            required: true

        messages:
          email:
            required: 'Не указан email'
            email   : 'Неверный формат'
          phone:
            required: 'Не указан контактный телефон'
      )


    onRender: ->
      # Если пользователь является менеджером - даем ему возможность выбрать агентство, под которым залогиниться
      if @model.get('type') is 'companyManager'
        @ui.name
          .removeClass('form-control')
          .selectize(
            maxItems   : 1
            searchField: ['name']
            sortField  : 'name'
            valueField : 'id'
            labelField : 'name'
            maxOptions : 10

            onItemAdd: (id) =>
              @model.set(customerAgencyCollection.get(id).toJSON())

            load: (query, callback) ->
              if not query.length then return callback()

              customerAgencyCollection.fetch(
                dataType: 'json'
                data:
                  'name': query
                success: (response) ->
                  callback(customerAgencyCollection.toJSON())
                error: ->
                  callback()
              )
          )

        @$('.selectize-input').addClass('form-control').find('input').css({width: 'auto'})

      @validate()