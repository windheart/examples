###

  Подсвечивает инпуты

  Важно: Данный обработчик зависит от объекта ui определенного для view!

###

define [
], ->


  class PayErrorHandlerHighliteFormGroup

    # Удаление подсветки
    valid: (view, key) ->
      $formGroup = @_getClosestFormGroup(view, key)
      $formGroup.removeClass('has-error')


    # Подсветка ошибки
    invalid: (view, key, err) ->
      $formGroup = @_getClosestFormGroup(view, key)
      $formGroup.addClass('has-error')


    _getClosestFormGroup: (view, key) ->
      return view.ui[key].closest('.form-group')


  return PayErrorHandlerHighliteFormGroup