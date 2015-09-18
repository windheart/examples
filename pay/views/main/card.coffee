define [
  'components/pay/component'
  'backbone'
  'components/core/env'
  'components/core/events'
  'marionette'
  'components/pay/templates/main/card'
  'components/pay/models/card'
  'components/pay/views/main/sum'
  'components/pay/views/main/card/error'
  'components/base/mixins/view/error-handler'
  'components/pay/views/mixins/error-handler/highlight-form-group'
  'components/pay/views/mixins/error-handler/highlight-pan'
  'components/core/utils/text'

  'jquery.groupinputs'

], (component, Backbone, env, events, Marionette, CardTemplate, cardModel, SumView, ErrorView, ErrorHandlerMixin, HighlightFormGroupError, HighlightPanError, textUtil) ->


  class CardView extends Marionette.Layout

    className: 'pay-card-view'

    template: CardTemplate

    model: cardModel


    events:
      'click  .pay-card-gate': 'prepare'

      # В safari после события input или keyup не срабатывает событие change (т.к. мы сами меняем значение input), потому вешаем на blur
      # В ie8 событие input не работает (Забиваем на него!)
      'blur .pay-card-attr': 'change'
      'input .pay-card-dg-code': 'inverseKeyboard'
      'keyup .pay-card-dg-code': 'inverseKeyboard' # ie8


    modelEvents:
      'change:error'     : 'toggleError'
      'change:sum'       : 'updateSumText'
      'validated:invalid': 'validationFail'


    regions:
      'sumText': '#pay-sum-total-region'
      'error'  : '#pay-card-error-region'


    ui: ->
      keys = ['dgCode', 'originalSum', 'pan', 'expireYear', 'expireMonth', 'cardholderName', 'cvc']
      values = _.map(keys, (key) -> ".pay-card-attr[name='#{key}']")
      return _.object(keys, values)


    initialize: ->
      # Подключаем и настраиваем обработчик ошибок
      options = {
        processValidatedErrors: false # Будем сами подсвечивать ошибки после валидации!
        defaultHandlers: new HighlightFormGroupError
        handlers:
          'pan': new HighlightPanError
      }
      new ErrorHandlerMixin(@, options)


    onRender: ->
      @toggleError()
      @updateSumText()
      @showLastErrorsState()
      @_groupInputs()
      @_setTooltip()
      @setPlaceholder()


    inverseKeyboard: (event) ->
      event.stopImmediatePropagation()
      ctrl = @$(event.currentTarget)
      inverse = textUtil.inverseRusKeyboard(ctrl.val())
      ctrl.val(inverse)


    change: (event) ->
      ctrl = @$(event.currentTarget)

      key = ctrl.prop('name')
      val = textUtil.trim(ctrl.val())

      # Заменяем точку на запятую
      if key is 'originalSum'
        val = val.replace(',', '.')

      # Применяем к форме (trim, преобразование запятой)
      ctrl.val(val)

      # Если меняется номер карты - пишем его массивом.
      switch key
        when 'pan'
          partIndex = parseInt(ctrl.data('part'))
          pan = @model.get('pan')
          pan[partIndex] = val
          val = pan
          @model.set(key, val)
          err = @model.preValidate(key, val)
          if err then err.partIndex = partIndex
          @processError(key, err)
        when 'expireMonth', 'expireYear'
          @model.set(key, val)
          expireMonth = @model.get('expireMonth')
          expireYear = @model.get('expireYear')
          # Валидируем только когда оба поля или заполненые или пустые
          if (expireMonth and expireYear) or (not expireMonth and not expireYear)
            attrs = {
              'expireMonth': expireMonth
              'expireYear': expireYear
            }
            err = @model.preValidate(attrs)
            @processErrors(_.keys(attrs), err)
        else
          @model.set(key, val)
          err = @model.preValidate(key, val)
          @processError(key, err)

      # Если меняется сумма, умножаем ее на курс соответствующей валюты.
      if key is 'originalSum' or key is 'currentCurrencyId'
        @model.set('sum', parseFloat(@model.get('originalSum') * @model.get('currencies').get(@model.get('currentCurrencyId')).get('rate')))


    prepare: (event) ->
      event.preventDefault()

      if @model.isValid(true)

        component.logCardUserAction('clickPayButton - form valid')
        @model.set('error', null)

        events.trigger('app:toggleLock', true)
        @$('.pay-card-gate').text('Загрузка...')

        dfdPrepare = component.makeRequest('preparePayment')
        dfdPrepare.done((data) =>
          # Будет произведен переход на 3DS, или сразу на подтверждение транзакции
          if data.is3DSRedirect
            component.logCardUserAction('3DSecureRedirect')
        ).fail((error)=>
          component.logCardUserAction(error)
          @render()
        ).progress((message)=>
          component.logCardUserAction(message)
        ).always(=>
          events.trigger('app:toggleLock', false)
        )
      else
        component.logCardUserAction('clickPayButton - form invalid')


    # Переключает регион с блоком ошибок
    toggleError: ->
      if @model.get('error')
        @error.show(new ErrorView)
        Marionette.$('body').animate({'scrollTop': 0}, 400)
      else
        @error.reset()


    validationFail: (model, errors) ->
      model.set('error', _.uniq(_.values(errors)))
      @processErrors(null, errors)


    # Преобразовываем введенную сумму платежа в текст.
    updateSumText: ->
      @sumText.show(new SumView(
        'model'   : new Backbone.Model(
          'sum': @model.get('sum')
        )
      ))


    _groupInputs: ->
      @ui.pan.groupinputs()


    _setTooltip: ->
      env.request('tooltip', @$('.pay-tooltip'))


  return CardView