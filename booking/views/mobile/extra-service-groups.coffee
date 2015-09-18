define [
  'components/tour/booking/views/default/extra-service-groups'
  'components/tour/booking/templates/mobile/extra-service-groups'
  'components/tour/booking/views/mobile/extra-service-groups/item'

], (DefaultExtraServiceGroupsView, MobileExtraServiceGroupsTemplate, MobileExtraServiceGroupItemView) ->

  class MobileExtraServiceGroupsView extends DefaultExtraServiceGroupsView

    className: 'list-group-item tour-booking-section'

    template: MobileExtraServiceGroupsTemplate

    childView: MobileExtraServiceGroupItemView