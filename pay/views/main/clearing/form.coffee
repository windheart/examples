define [
  'backbone'
  'marionette'
  'components/core/events'
  'components/core/utils/http'
  'components/core/utils/text/crypt'
  'components/pay/models/clearing/form'
  'components/pay/templates/main/clearing/form'
  'components/pay/views/main/card/error'
  'components/base/mixins/view/error-handler'
  'components/pay/views/mixins/error-handler/highlight-form-group'
  'backbone.stickit'

], (Backbone, Marionette, events, httpUtil, cryptUtil, formModel, formTemplate, ErrorView, ErrorHandlerMixin, HighlightFormGroupError) ->

  class FormView extends Marionette.ItemView

    model: formModel

    template: formTemplate

    ui:
      'sendButton'        : '.save'
      'dgCode'            : '.pay-dg-code'
      'originalSum'       : '.pay-order-sum'
      'currentCurrencyId' : '.pay-currency'
      'errors'            : '.pay-clearing-error'

    errorHandler:
      handlers:
        'dgCode'          : 'highlight-input'
        'originalSum'     : 'highlight-input'


    bindings:
      '.pay-dg-code'      : 'dgCode'
      '.pay-order-sum'    : 'originalSum'
      '.pay-currency'     : 'currentCurrencyId'

    modelEvents:
      'change:error'     : 'render'
      'validated:invalid' : 'validationFail'
      'sync'              : 'saveSuccess'
      'error'             : 'saveFail'
      'request'           : 'saveProcess'

    events:
      'click @ui.sendButton': 'saveDoc'

    initialize: ->
      options = {
        processValidatedErrors: false
        defaultHandlers: new HighlightFormGroupError
      }
      new ErrorHandlerMixin(@, options)


    onRender: =>
      @stickit(@model)

      @_setAlert()


    _setAlert: ->
      console.log 'test'
      @$('.pay-ui-clearing-error').bind('close', =>
        @model.set('error': null)
      )

    validationFail: (model, errors) ->
      model.set('error', _.uniq(_.values(errors)))
      @processErrors(null, errors)

    saveSuccess: (@model, response, options) =>
      @ui.sendButton.removeClass('disabled').removeAttr('disabled')
      window.location.href = model.toRedirect() + '?' + httpUtil.param(response)

    saveFail: (@model, response, options) =>
      @ui.sendButton.removeClass('disabled').removeAttr('disabled')
      if response.responseJSON
       #@ui.errors.html(response.responseJSON.errorMessage)
       model.set('error', response.responseJSON.errorMessage)

    saveProcess: (@model, xhr, options) =>
      @ui.sendButton.addClass('disabled').attr('disabled','disabled')

    saveDoc: =>
      @model.set('hash',cryptUtil.md5("#{@model.get('dgCode')}_#{@model.get('originalSum')}"))
      @model.save()

