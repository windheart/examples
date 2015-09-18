define [
  'marionette2'
  'components/core/layout2'
  'components/tour/parametric-search/templates/desktop/form'
  'components/tour/parametric-search/models/search'
  'components/tour/parametric-search/views/desktop/result'
  'components/tour/parametric-search/views/desktop/info'
  'components/core/utils/text'
  'components/core/utils/html'
  'domReady'
  'bootstrap.datepicker.ru'

], (Marionette, layout, FormTemplate, SearchModel, ResultView, InfoView, textUtil, htmlUtil, domReady) ->

  class FormView extends Marionette.ItemView

    className: 'panel tour-parametric-search-form clearfix'

    template: FormTemplate

    model: new SearchModel

    ui:
      'dateMin': 'input[name=dateMin]'
      'dateMax': 'input[name=dateMax]'
      'dateRange': '.input-daterange'
      'catalog': 'select[name=currentCatalogId]'
      'partition': 'select[name=currentPartitionId]'
      'date': '.tour-parametric-search-form-date'
      'submit': 'button[type=submit]'
      'selectizeInput': '.selectize-input input'

    templateHelpers:
      textUtil: textUtil
      htmlUtil: htmlUtil

    events:
      'change .form-control': '_changeModel'
      'click @ui.submit': '_submitForm'
      'keyup @ui.selectizeInput': '_inverseKeyboard'

    modelEvents:
      'change:currentCatalogId': '_updatePartitions'
      'change:currentPage': '_fetchModel'
      'invalid request': 'render'


    initialize: ->
      @listenTo(@model.get('catalogs'), 'sync', @render)
      @listenTo(@model.get('partitions'), 'sync', @render)
#      @model.get('catalogs').fetch()

      domReady( =>
        @domReady = true
        @$el.fadeIn()
      )


    onBeforeRender: ->
      if not @domReady
        @$el.hide()


    onRender: ->
      @ui.dateRange.datepicker(
        'language' : 'ru'
        'autoclose': true
        'format'   : 'dd.mm.yyyy'
      )
      @ui.date.mask('99.99.9999')
      @ui.catalog.selectize()
      @ui.partition.selectize()


    _inverseKeyboard: (event) ->
      ctrl = @$(event.currentTarget)


    _submitForm: (event) ->
      event.preventDefault()
      if @model.isValid()
        @model.set('currentPage', 1, {silent: true})
        @_fetchModel()


    _fetchModel: ->
      @model.fetch(
        data: @model.toQuery()
        success: =>
          if not @model.get('prices').length
            return layout.getRegion('parametricSearchResult').show(new InfoView(
              model: @model
            ))

          return layout.getRegion('parametricSearchResult').show(new ResultView(
            model: @model
          ))
      )


    _changeModel: (event) ->
      ctrl = @$(event.currentTarget)
      if ctrl.val() then @model.set(ctrl.prop('name'), ctrl.val())


    _updatePartitions: ->
      @model.get('partitions').fetch(
        data:
          parentId: @model.get('currentCatalogId')
      )
      @model.set('currentPartitionId', null)

