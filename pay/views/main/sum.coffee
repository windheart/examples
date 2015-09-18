define [
  'marionette'
  'components/pay/templates/main/sum'
  'components/core/utils/text'

], (Marionette, SumTemplate, textUtil) ->


  templateHelpers = {

    renderSumWords: ->
      return textUtil.numberToWords(@sum) + ' ' + textUtil.numberSuffix(@sum, 'рубль', 'рубля', 'рублей')


    renderSumValue: ->
      textUtil.numberFormat(@sum, 2, '.', ' ')
  }


  class PaySumView extends Marionette.ItemView

    template: SumTemplate

    templateHelpers: templateHelpers
