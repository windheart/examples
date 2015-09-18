define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/tour'
  'components/tour/booking/models/tour'

], (Marionette, channel, TourTemplate, tourModel) ->

  class TourView extends Marionette.ItemView

    className: 'row tour-booking-section'

    template: TourTemplate

    templateHelpers:
      isSelectable: (variants) ->
        return variants.length > 1

      getFirstVariant: (variants) ->
        return _.first(variants)

    events:
      'change #tour-booking-variant': 'changeModel'

    model: tourModel


    changeModel: (event) ->
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), ctrl.val())

      channel.vent.trigger('change:tourModel')


