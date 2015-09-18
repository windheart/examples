define [
  'marionette2'
  'components/tour/parametric-search/templates/desktop/info'
  'moment'

], (Marionette, InfoTemplate, moment) ->

  class InfoView extends Marionette.ItemView

    className: 'palette palette-wet-asphalt tour-parametric-search-info'

    template: InfoTemplate

    templateHelpers:
      moment: moment
