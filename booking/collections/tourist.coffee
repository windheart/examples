define [
  'baseCollection'
  'components/tour/booking/models/tourist'

], (BaseCollection, TouristModel) ->

  class TouristCollection extends BaseCollection

    model: TouristModel


    comparator: (tourist) ->
      return -tourist.getAge()


  return new TouristCollection