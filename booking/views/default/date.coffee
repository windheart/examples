define [
  'marionette2'
  'components/tour/booking/channel'
  'components/tour/booking/templates/default/date'
  'components/tour/booking/models/date'
  'moment'
  'components/core/utils/text'
  'bootstrap.datepicker.ru'

], (Marionette, channel, DateTemplate, dateModel, moment, textUtil) ->

  class DateView extends Marionette.ItemView

    className: 'row tour-booking-section'

    template: DateTemplate

    templateHelpers:
      getEnd: (currentVariantId, duration) =>
        return moment(currentVariantId).add(duration - 1, 'days').format('D MMMM YYYY, dddd')

      getDuration: (duration) =>
        return "#{duration} #{textUtil.numberSuffix(duration, 'день', 'дня', 'дней')}"


    ui:
      'date': '#tour-booking-date .form-control'

    events:
      'click #tour-booking-date button': 'showDatepicker'

    model: dateModel


    onRender: ->
      dates = @model.get('variants')
      first = moment(_.first(@model.get('variants')))
      last  = moment(_.last(@model.get('variants')))

      @ui.date.datepicker(
        'language'     : 'ru'
        'autoclose'    : true
        'format'       : 'yyyy-mm-dd'
        'startDate'    : first.format('YYYY-MM-DD')
        'endDate'      : last.format('YYYY-MM-DD')
        'beforeShowDay': (date) ->
          if _.contains(dates, moment(date).format('YYYY-MM-DD'))
            return {
              classes: 'tour-booking-available-day'
            }
          else
            return false
      ).on('hide', (e) =>
        if moment().unix() isnt moment(e.date).unix()
          @ui.date.val(moment(e.date).format('с D MMMM YYYY, dddd'))
          @model.set('currentVariantId', moment(e.date).format('YYYY-MM-DD'))

          channel.vent.trigger('change:dateModel')
      )

      current = moment(@model.get('currentVariantId'))
      @ui.date.datepicker('setDate', current.format('YYYY-MM-DD'))
      @ui.date.val(current.format('с D MMMM YYYY, dddd'))


    showDatepicker: ->
      @ui.date.datepicker('show')


