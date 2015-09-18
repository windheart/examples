define [
  'components/pay/views/mixins/error-handler/highlight-form-group'
], (PayErrorHandlerHighliteFormGroup) ->

  class PayErrorHandlerHighlitePan extends PayErrorHandlerHighliteFormGroup


    # Подсветка ошибки
    invalid: (view, key, err) ->
      partIndex = err.partIndex

      # Если передали индекс, то обрабатываем только одну часть
      if not _.isUndefined(partIndex)
        parts = []
        parts[partIndex] = err.parts[partIndex]
      else
        parts = err.parts

      for i, isValid of parts
        $formGroup = @_getClosestFormGroup(view, key)
        $formGroup.eq(i).toggleClass('has-error', not isValid)


  return PayErrorHandlerHighlitePan