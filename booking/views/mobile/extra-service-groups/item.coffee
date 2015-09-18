define [
  'components/tour/booking/views/default/extra-service-groups/item'
  'components/tour/booking/templates/mobile/extra-service-groups/item'
  'components/tour/booking/views/mobile/extra-service-groups/item/service'

], (DefaultExtraServiceGroupItemView, MobileExtraServiceGroupItemTemplate, MobileExtraServiceItemView) ->

  class MobileExtraServiceGroupItemView extends DefaultExtraServiceGroupItemView

    template: MobileExtraServiceGroupItemTemplate

    childView: MobileExtraServiceItemView