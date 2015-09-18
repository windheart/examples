define [
  'backbone'

], (Backbone) ->

  class SexCollection extends Backbone.Collection

    model: Backbone.Model


    initialize: ->
      @reset([
        {'id': 1, 'name': 'Мужчина'}
        {'id': 2, 'name': 'Женщина'}
        {'id': 3, 'name': 'Ребенок'}
      ])


  return new SexCollection