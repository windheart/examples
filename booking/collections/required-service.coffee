define [
  'baseCollection'
  'components/tour/booking/models/service'

], (BaseCollection, ServiceModel) ->

  class RequiredServiceCollection extends BaseCollection

    model: ServiceModel


  return new RequiredServiceCollection