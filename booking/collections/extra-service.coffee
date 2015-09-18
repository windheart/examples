define [
  'baseCollection'
  'components/tour/booking/models/service'

], (BaseCollection, ServiceModel) ->

  class ExtraServiceCollection extends BaseCollection

    model: ServiceModel


  return new ExtraServiceCollection