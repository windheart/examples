define [
  'marionette'
  'components/base/component'
  'components/core/utils/debug'
  'jquery.crypt'
], (Marionette, BaseComponent, debugUtil) ->

  class PayComponent extends BaseComponent


    # Логируем действия пользователя
    logUserAction: (action) ->
      category = 'pay.dsbw'
      label = @getUserSessionId()
      debugUtil.logUserAction(category, action, label)


    # Логируем действия пользователя по карточке
    # Добавляем код заказа если он есть
    logCardUserAction: (action) ->
      dgCode = @makeRequest('getPaymentOrderDgCode')
      prefix = 'card: '
      suffix = if dgCode then " (dgCode: #{dgCode})" else ''
      @logUserAction(prefix + action + suffix)


  return new PayComponent('pay')
