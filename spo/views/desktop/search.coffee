define [
  'marionette2'
  'components/spo/templates/desktop/search'
  'moment'
  'components/core/utils/html'
  'bootstrap.datepicker.ru'

], (Marionette, SearchTemplate, moment, htmlUtil) ->

  class SearchView extends Marionette.ItemView

    tagName: 'form'

    template: SearchTemplate

    templateHelpers:
      htmlUtil: htmlUtil

      getColorClass: (id) ->
        switch id
          when 'best'  then return 'info'
          when 'super' then return 'danger'
          when 'early' then return 'success'
          else return 'primary'

      getDate: (date) ->
        if date
          return moment(date).format('DD.MM')

    ui:
      'dateRange': '.input-daterange'
      'catalog': '.spo-catalog .form-control'

    events:
      'change @ui.catalog': '_changeModel'

    modelEvents:
      'change:id': 'render'


    _changeModel: (event) ->
      ctrl = @$(event.currentTarget)
      @model.set(ctrl.prop('name'), ctrl.val())


    onRender: ->
      @ui.dateRange.datepicker(
        'language'     : 'ru'
        'autoclose'    : true
        'format'       : 'dd.mm'
      ).on('changeDate', (event) =>
        @model.set(@$(event.target).prop('name'), moment(event.date).format('YYYY-MM-DD'))
      )

      @ui.catalog.selectize()