define [
  'backbone'

], (Backbone) ->

  class DateCollection extends Backbone.Collection

    model: Backbone.Model


  return new DateCollection