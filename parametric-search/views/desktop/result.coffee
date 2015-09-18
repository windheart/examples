define [
  'marionette2'
  'backbone'
  'components/tour/parametric-search/templates/desktop/result'
  'components/core/utils/text'
  'components/core/utils/html'
  'moment'

], (Marionette, Backbone, ResultTemplate, textUtil, htmlUtil, moment) ->

  class ResultView extends Marionette.LayoutView

    className: 'panel panel-default tour-parametric-search-result'

    template: ResultTemplate

    templateHelpers:
      textUtil: textUtil
      htmlUtil: htmlUtil
      moment: moment

    ui:
      'page': '.pagination a'

    events:
      'click @ui.page': '_gotoPage'


    _gotoPage: (event) ->
      event.preventDefault()
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), ctrl.data('value'))
      Backbone.$('body').animate({'scrollTop': @$el.offset().top}, 400)

