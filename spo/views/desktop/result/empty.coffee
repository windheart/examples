define [
  'marionette2'
  'components/spo/templates/desktop/result/empty'

], (Marionette, EmptyItemTemplate) ->

  class EmptyItemView extends Marionette.ItemView

    className: 'spo-item spo-item-empty'

    template: EmptyItemTemplate