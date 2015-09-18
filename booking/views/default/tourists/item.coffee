define [
  'marionette2'
  'backbone'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/tourists/item'
  'components/core/utils/text'
  'components/tour/booking/templates/default/tourists/item/help'
  'jquery.validation'
  'jquery.maskedinput'

], (Marionette, Backbone, channel, TouristTemplate, textUtil, HelpTemplate) ->

  class TouristItemView extends Marionette.ItemView

    className: 'tour-booking-tourist'

    tagName: 'form'

    template: TouristTemplate

    templateHelpers:
      isSelectedSex: (currentSex, sex) ->
        if currentSex is sex
          return 'btn-primary active'
        else
          return 'btn-default'

    ui:
      'birthday'         : '.tour-booking-tourist-birthday .form-control'
      'sex'              : '.tour-booking-tourist-sex button'
      'passportValidTill': '.tour-booking-passport-valid-till .form-control'
      'name'             : '.tour-booking-tourist-name'
      'isSocial'         : '.tour-booking-tourist-social-toggle'
      'socialHelp'       : '.tour-booking-tourist-show-social-help'

    events:
      'change .form-control': 'changeModel'
      'click @ui.sex'       : 'changeModel'
      'click @ui.isSocial'  : '_toggleIsSocial'
      'click @ui.socialHelp': '_showSocialHelp'
      'keyup @ui.name'      : '_translit'

    modelEvents:
      'change:sex change:isSocial': 'render'


    initialize: ->
      @listenTo(channel.vent, 'validationRequest', @validationRequest)

      Backbone.$.validator.addMethod(
        'regexp'
        (value, element, regexp) ->
          re = new RegExp(regexp)
          return this.optional(element) || re.test(value)
      )


    validationRequest: ->
      channel.vent.trigger('validationResponse', @$el.valid())


    validate: ->
      @$el.validate(
        highlight: (ctrl, errorClass, validClass) =>
          formGroup = @$(ctrl).parents('.form-group')

          formGroup.addClass(errorClass)
            .removeClass(validClass)

          if not formGroup.hasClass('has-date')
            formGroup.removeClass('has-feedback')
            .find('.form-control-feedback')
            .remove()

        unhighlight: (ctrl, errorClass, validClass) =>
          formGroup = @$(ctrl).parents('.form-group')

          if @$(ctrl).val() is '__.__.____'
            formGroup.removeClass(validClass)
            return false

          formGroup.removeClass(errorClass)
            .addClass('has-feedback')
            .addClass(validClass)

          if not formGroup.hasClass('has-date')
            formGroup.find('input').after('<span class="glyphicon glyphicon-ok form-control-feedback"></span>')

          formGroup.find('.help-block').remove()

        errorElement: 'span'

        errorPlacement: (error, ctrl) =>
          formGroup  = @$(ctrl).parents('.form-group')
          inputGroup = formGroup.find('.input-group')
          error.addClass('help-block').removeClass('has-error')

          if formGroup.find('.help-block').length
            return

          if inputGroup.length
            inputGroup.after(error)
          else
            ctrl.after(error)

        errorClass: 'has-error'

        validClass: 'has-success'

        rules:
          firstNameRu:
            required: true
          lastNameRu:
            required: true
          birthday:
            required: true
            regexp  : '(0[1-9]|[12][0-9]|3[01])\.(0[1-9]|1[012])\.(19|20)\\d\\d'

        messages:
          firstNameRu:
            required: 'Не указано имя'
          lastNameRu:
            required: 'Не указана фамилия'
          birthday:
            required: 'Не указана дата рождения'
            regexp  : 'Неверный формат даты'
      )


    changeModel: (event) ->
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), ctrl.val() or ctrl.data('value'))


    _toggleIsSocial: ->
      @model.set('isSocial', not @model.get('isSocial'))


    _showSocialHelp: (event) ->
      event.preventDefault()
      ctrl = @$(event.currentTarget)
      channel.vent.trigger('before:show:modal',
        template: HelpTemplate
        model: new Backbone.Model(
          socialNetwork: ctrl.data('socialNetwork')
        )
      )


    onRender: ->
      @ui.birthday.mask('99.99.9999')
      @ui.passportValidTill.mask('99.99.9999')
      @validate()


    _translit: (event) ->
      ctrl   = @$(event.currentTarget)
      value  = textUtil.translitToLat(ctrl.val())
      target = ctrl.data('translit')

      @model.set(target, value)
      @$("input[name=#{target}]").val(value)
