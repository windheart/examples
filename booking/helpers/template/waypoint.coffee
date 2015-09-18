define [
  'backbone'
  'components/core/utils/text'
  'components/core/utils/text/geo'

], (Backbone, textUtil, geoUtil) ->

  class WaypointTemplateHelper

    getCityName: (cityName) ->
      return geoUtil.getCityNameCaseForm(cityName, 'im', true)

    getHotelName: (hotelName) ->
      return textUtil.ucwords(hotelName).replace(/\d+/g, '')


    getVariantName: (variant) ->

      # По указанию Карена Twin пишем как Double, чтобы не было проблем с туристами при заселении
      names  = {
        'Single'   : '1 взрослый'
        'Double'   : '2 взрослых'
        'Twin'     : '2 взрослых'
        'Triple'   : '3 взрослых'
        'Tripl'    : '3 взрослых'
        'Quadriple': '4 взрослых'
      }

      currentName = variant.name

      # Проверяем, не номер ли это с ребенком на основном месте
      regexp = new RegExp('Реб.*осн', 'ig')
      if regexp.test(currentName)
        return "Взрослый + ребенок от #{variant.ageMin} до #{variant.ageMax} #{textUtil.numberSuffix(variant.ageMax, 'год', 'года', 'лет')}"

      # Убираем категорию номера из названия
      currentName = currentName.replace(/\([\S0-9\s\-]*\)/g, '')

      # Убираем слово "Взрослый" и "Ребенок"
      currentName = currentName.replace(/,\s*(Взрослый|Ребенок|Весь\sкоттедж).*/, '')

      # Убираем мусор из названий номеров на паромах
      currentName = currentName.replace(/,\s*[1-4]\s*осн\./, '')

      # Убираем пробелы по краям
      currentName = currentName.replace(/^\s*|\s*$/g, '')

      # Пробуем найти варианты из имеющихся названий
      currentName = names[currentName] or currentName

      if not variant.isPrimary
        if variant.ageMax and variant.ageMax < 99
          currentName = "Ребенок от #{variant.ageMin} до #{variant.ageMax} #{textUtil.numberSuffix(variant.ageMax, 'год', 'года', 'лет')}"
        else
          currentName = "Взрослый"

      return currentName


    getMealName: (mealName) ->
      names  = ['Завтрак', 'Полупансион', 'Полный пансион']

      currentName = mealName
      _.each(names, (name) ->
        regexp = new RegExp(name, 'i')
        if regexp.test(currentName)
          currentName = name
      )

      return currentName


    getHotelPageUrl: (hotelId) ->
      return "http://dsbw.ru/hotel/#{hotelId}"


    isSelected: (arg1, arg2) ->
      if arg1 is arg2 then return 'selected="selected"'


  return new WaypointTemplateHelper