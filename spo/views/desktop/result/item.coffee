define [
  'marionette2'
  'components/core/channel'
  'components/spo/templates/desktop/result/best'
  'components/spo/templates/desktop/result/super'
  'components/spo/templates/desktop/result/early'
  'components/core/utils/text'
  'components/core/utils/debug'

], (Marionette, channel, BestTemplate, SuperTemplate, EarlyTemplate, textUtil, debugUtil) ->

  class ItemView extends Marionette.ItemView

    className: 'spo-item'

    templateHelpers:
      getName: (name) ->
        return textUtil.ucfirst(name)
      getPrice: (textWithPrice) ->
        return textWithPrice.substr(textWithPrice.indexOf('от '), textWithPrice.length).replace('€', ' €')
      getCurrency: (currency) ->
        switch currency
          when 'USD' then return '$'
          when 'EUR' then return '&euro;'
          else return 'руб.'
      getDetails: (details) ->
        return details.replace(/Дата заезда/g, 'Заезд')

    events:
      'click .spo-item-print': 'logPrintAction'


    getTemplate: ->

      switch channel.reqres.request('spoSearchId')
        when 'super' then return SuperTemplate
        when 'early' then return EarlyTemplate
        else return BestTemplate


    logPrintAction: (event) ->
      debugUtil.logUserAction('dsbw.ru', 'printSpo')