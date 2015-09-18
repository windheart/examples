define [
  'baseModel'

], (BaseModel) ->

  class TechSupportFormModel extends BaseModel

    defaults:
      'message': ''
      'status' : ''
      'tourId' : ''
      'comment': ''

    url: '/tour/send-feedback'