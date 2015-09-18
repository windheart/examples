define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/mobile/extra-service-groups/item/service'
  'components/tour/booking/collections/tourist'
  'components/tour/booking/collections/waypoint'
  'components/core/utils/text'

], (Marionette, channel, ExtraServiceItemTemplate, touristCollection, waypointCollection, textUtil) ->

  class ExtraServiceItemView extends Marionette.ItemView

    tagName: 'tr'

    template: ExtraServiceItemTemplate

    templateHelpers: ->
      return {
        normalizeName: (name) =>
          return name.substr(name.indexOf('\/') + 1, name.length) or ''

        getNumWithText: (num, form1, form2, form3) =>
          return "#{num} #{textUtil.numberSuffix(num, form1, form2, form3)}"

        isSelected: (arg1, arg2) =>
          if arg1 is arg2 then return 'selected="selected"'

        getPrice: (price, currentTouristQuantity) =>
          switch price.currency
            when 'Eu' then symbol = '&euro;'
            else symbol = '&dollar;'

          return "#{price.value} <small>X</small> #{currentTouristQuantity} = #{price.value * currentTouristQuantity or 0} #{symbol}"

        isActive: =>
          if @model.get('isActive') then return 'checked="checked"' else return ''

        isAdditional: =>
          if @model.isAdditional() then return 'disabled="disabled"' else return ''

        labels: =>
          labels = '<div>'

          text = ''
          if @model.get('ageMin') > 0
            text += "от #{@model.get('ageMin')} "
            if not @model.get('ageMax') or @model.get('ageMax') >= 99
              text += "#{textUtil.numberSuffix(@model.get('ageMin'), 'год', 'года', 'лет')}"

          if @model.get('ageMax') > 0 and @model.get('ageMax') < 99
            text   += "до #{@model.get('ageMax')} #{textUtil.numberSuffix(@model.get('ageMax'), 'год', 'года', 'лет')}"

          if text
            labels += "<span class='label label-warning'>#{text}</span>"

          labels += '</div>'

          return labels
      }


    events:
      'change .form-control'      : '_changeModel'
      'click input[type=checkbox]': '_toggleActive'


    modelEvents:
      'change': 'render'


    initialize: ->
      @listenTo(channel.vent, 'after:prepare:touristCollection', @_changeCurrentTouristQuantityOnEvent)


    _changeModel: (event) ->
      event.preventDefault()
      @_changeCurrentTouristQuantity(parseInt(@$(event.currentTarget).val()))


    _toggleActive: ->
      @model.set('isActive', not @model.get('isActive'))
      @_changeCurrentTouristQuantity(if not @model.get('isActive') then 0 else touristCollection.length)


    _changeCurrentTouristQuantityOnEvent:  ->
      if @model.get('isActive') then @_changeCurrentTouristQuantity()


    _changeCurrentTouristQuantity: (touristQuantity = touristCollection.length) ->
      # Если услуга выбрана по умолчанию в админе - выбираем ее для всех туристов при изменении их количества в туре
      currentTouristQuantity = touristQuantity

      @model.set(
        'currentTouristQuantity': currentTouristQuantity
        'isActive': touristQuantity > 0
      )
      channel.vent.trigger('after:change:extraServiceModel')


    serializeData: ->
      return _.extend(@model.toJSON(),
        'touristQuantity': touristCollection.length
      )


    onRender: ->
      if @model.get('isActive')
        @$el.addClass('active')
      else
        @$el.removeClass('active')