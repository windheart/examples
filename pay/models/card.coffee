define [
  'marionette'
  'baseModel'
  'components/pay/component'
  'components/pay/models/default'
  'components/core/utils/http'
  'components/core/utils/text'
  'components/base/mixins/model/validation'
  'moment'

], (Marionette, BaseModel, component, coreModel, httpUtil, textUtil, validation, moment) ->

  class PayCardModel extends BaseModel

    defaults:
      'id'                     : 'register'
      'dgCode'                 : coreModel.get('dgCode')
      'originalSum'            : coreModel.get('originalSum')
      'sum'                    : coreModel.get('sum') or null
      'pan'                    : []
      'expireMonth'            : null
      'expireYear'             : null
      'cardholderName'         : ''
      'cvc'                    : null
      'transactionId'          : null
      'processingTransactionId': ''
      'paymentDate'            : ''
      'sumPayed'               : 0
      'sumRemaining'           : 0
      'manager'                : ''
      'tourist'                : ''
      'hasProfile'             : coreModel.get('hasProfile')
      'specificReturnUrl'      : if coreModel.get('search') is 'meta' then "#{coreModel.get('baseUrl')}/index/new/search/meta/#card/process" else "#{coreModel.get('baseUrl')}/index/new#card/process"
      'error'                  : null
      'currentCurrencyId'      : coreModel.get('currency') or 'rub'
      'currencies'             : coreModel.get('currencies')
      'lockOrder'              : !!coreModel.get('dgCode')
      'lockSum'                : !!coreModel.get('originalSum') and !!coreModel.get('currency')


    initialize: ->
      if coreModel.get('paymentVariant') then @set('specificReturnUrl', "#{coreModel.get('baseUrl')}/index/new?paymentVariant=#{coreModel.get('config', 'paymentVariant')}#card/process")

      # Назначаем команды
      component.reqres.setHandler('preparePayment', @_prepareHandler, @)
      component.reqres.setHandler('confirmPayment', @_confirmHandler, @)
      component.reqres.setHandler('getPaymentOrderDgCode', @_getDgCodeHandler, @)

      # Добавляем валидацию к модели
      _.extend(@, validation.mixin)


    # Правила валидации
    validation:
      dgCode:
        required: true
        msg: 'Не указан номер заказа'
      originalSum:
        fn: 'validateSum'
      pan:
        fn: 'validatePan'
      expireMonth:
        fn: 'validateMonthAndYear'
      expireYear:
        fn: 'validateMonthAndYear'
      cardholderName:
        required: true
        msg: 'Не указан владелец карты'
      'cvc':
        fn: 'validateCVC'

    # ----- Методы для валидации ------------------------------

    validatePan: (val) ->
      # Проверка заполнения для каждой части
      isValid = true
      parts = {}
      for i in [0..3] by 1
        regexp = if i is 3 then /^\d{2,8}$/ else /^\d{4}$/
        parts[i] = regexp.test(val[i])
        isValid = isValid and parts[i]
      msg = 'Номер карты указан неверно'
      return if isValid then null else {
        'msg'     : msg
        'parts'   : parts
        'toString': -> return @msg # Важно!
      }


    validateCVC: (val) ->
      isValid = /^\d{3}$/.test(val) # 3 цифры
      msg = 'Неправильно введен CVV2/CVC2 код'
      return if isValid then null else msg


    validateSum: (val) ->
      isValid = parseFloat(val) > 0
      msg = 'Неправильно указана сумма к оплате'
      return if isValid then null else msg


    validateMonthAndYear: (val, key, attrs) ->
      month = attrs.expireMonth
      year = attrs.expireYear

      isMonthValid = (1 <= parseInt(month) <=12)
      isYearValid = parseInt(year) >= (new Date).getFullYear()

      msg = 'Срок действия карты истек'

      if isMonthValid and isYearValid
        # Вычитаем 1 потому что month [0 - 11] http://javascript.ru/Date
        expire = moment([year, month-1 , 1]).add('month', 1).toDate()
        now = new Date()
        isValid = expire > now
        return if isValid then null else msg
      else
        return msg


    # ----- Методы для валидации (конец) ------------------------------

    # Для работы оплаты с других доменов, принудительно указываем посылать запросы на pay.dsbw
    urlRoot: ->
      url = "#{document.location.protocol}//pay.dsbw"
      url += if component.isDevMode() then '.local' else '.ru'
      url += '/index'
      return url


    fetch: (options) ->
      return super(_.extend({
        'data': @toQuery()
      }, options))


    resetProcessingData: ->
      @set(
        'id'                     : 'register'
        'transactionId'          : null
        'processingTransactionId': null
      )
      return @


    toQuery: ->
      @set(
        'statusCode': null
        'error'     : null
      )

      switch @id
        # Регистрация заказа.
        when 'register' then return _.pick(@toJSON(), 'dgCode', 'sum', 'specificReturnUrl')
        # Подтверждение заказа.
        when 'confirm'  then return _.pick(@toJSON(), 'transactionId', 'processingTransactionId')
        # Процессинг заказа.
        else
          return _.extend(_.pick(@toJSON(), 'expireMonth', 'expireYear', 'cardholderName', 'cvc', 'transactionId', 'processingTransactionId'), {'pan': @get('pan').join('')})


    parse: (response) ->

      # Если есть ошибка
      if response.statusCode isnt 1

        isLocalError = !!response.isLocalError
        errorDescription = textUtil.trim(response.errorDescription)

        # Текст ошибки для случая когда сообщение почему-то пустое!
        defaultErrorDescription = switch @id
          when 'register' then 'payment-register-empty-error'
          when 'payment-details' then 'payment-details-empty-error'
          when 'confirm'  then 'payment-confirm-empty-error'


        # Преобразуем ошибку в объект!
        error = {
          'description': errorDescription or defaultErrorDescription
          'isLocal'    : isLocalError
          'toString'   : -> return (if isLocalError then "#{@description} (LOCAL)" else @description)
        }

        response.error = error

        delete response.errorDescription
        delete response.isLocalError

      return response

          
    # Подготовка и опалата заказа
    _prepareHandler: (params) ->

      if params then @set(params)

      dfdPrepare = Marionette.$.Deferred()

      dfdRegister = Marionette.$.Deferred()
      dfdDetails = Marionette.$.Deferred()

      # Получение информации об оплате
      dfdPrepare.notify('registerStart') # Начало регистрации транзакции

      # Рекурсивная ф-ия для запроса на регистрацию транзакции
      #  maxAttempts - количество попыток
      #  _currAttempt - номер текущей попытки (внутренний параметр)
      registerRecursiveFunc = (maxAttempts, _currAttempt = 1) =>

        dfdPrepare.notify('registerAttempt - ' + _currAttempt)

        @resetProcessingData()
        .fetch(
          'success': =>
            if @get('statusCode') is 1
              dfdRegister.resolve()
            else
              error = @get('error')
              # Выходим из рекурсии если ошибка локальная или превышено число попыток
              if error.isLocal or _currAttempt >= maxAttempts
                dfdRegister.reject(error)
              else
                dfdPrepare.notify(error)
                registerRecursiveFunc(maxAttempts, _currAttempt+1)

          'error': =>
            error = 'payment-register-ajax-error'
            if _currAttempt >= maxAttempts
              @set('error', error)
              dfdRegister.reject(error)
            else
              dfdPrepare.notify(error)
              registerRecursiveFunc(maxAttempts, _currAttempt+1)
        )

      # Пробуем регистрировать транзакция 3 раза!
      registerRecursiveFunc(3)

      # Если детали успешно получены
      dfdRegister.done( =>
        dfdPrepare.notify('processStart') # Начало процессинга
        @set('id', 'payment-details')
        .fetch(
          'success': =>
            if @get('statusCode') is 1
              dfdDetails.resolve()
            else
              error = @get('error')
              dfdDetails.reject(error)
          'error': =>
            error = 'payment-details-ajax-error'
            @set('error', error)
            dfdDetails.reject(error)
        )
      ).fail((error) =>
        dfdPrepare.reject(error)
      )

      # Если данные успешно обработаны
      dfdDetails.done( =>

        is3DSRedirect = !!(@get('acsUrl') and @get('acsRedirectUrl') and @get('paReq')) # toBoolean!

        resolveData = {
          'transactionId': @get('transactionId')
          'orderId': @get('processingTransactionId')
          'is3DSRedirect': is3DSRedirect
        }

        # Переход на страницу подтверждения через СМС
        if is3DSRedirect

          # Создаем форму
          $form = Marionette.$('<form>', {
            'method': 'POST'
            'action': @get('acsUrl')
          })
          for name, attr of {'MD': 'processingTransactionId', 'PaReq': 'paReq', 'TermUrl': 'acsRedirectUrl'}
            $form.append(Marionette.$('<input>', {'name': name, 'value': @get(attr)}))

          dfdPrepare.resolve(resolveData)

          # ОБЯЗАТЕЛЬНО! Добавляем форму в DOM и выносим ее за пределы экрана
          $form.css({'position': 'absolute', top: '-200px'}).appendTo('body')

          # Отправляем форму (уход со страницы)
          $form.submit()

        else

          dfdPrepare.resolve(resolveData)

          # Переход по ссылке (уход со страницы)
          document.location.href = @get('specificReturnUrl') + '?' + httpUtil.param(resolveData)

      ).fail((error) =>
        dfdPrepare.reject(error)
      )

      return dfdPrepare.promise()


    # Подтверждение оплаты заказа
    _confirmHandler: (params) ->

      dfdConfirm = Marionette.$.Deferred()

      @set(
        'id'                     : 'confirm'
        'transactionId'          : params.transactionId
        'processingTransactionId': params.orderId
      )
      .fetch(
        'success': =>
          if @get('statusCode') is 1
            dfdConfirm.resolve()
          else
            error = @get('error')
            dfdConfirm.reject(error)
        'error': =>
          error = 'payment-confirm-ajax-error'
          @set('error', error)
          dfdConfirm.reject(error)
      )

      return dfdConfirm.promise()


    # Возвращает текущий код заказа
    _getDgCodeHandler: ->
      return @get('dgCode')

          
  return new PayCardModel