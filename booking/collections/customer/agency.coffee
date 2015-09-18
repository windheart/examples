define [
  'backbone'

], (Backbone) ->

  class CustomerAgencyCollection extends Backbone.Collection

    url: '/tour/find-booking-agencies'


  return new CustomerAgencyCollection