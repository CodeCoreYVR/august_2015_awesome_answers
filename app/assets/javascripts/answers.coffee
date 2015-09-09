# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  a = 5
  b = 10
  c = 15 if b > 10
  # a function that takes a single parameter word
  capitalize = (word)->
    word.charAt(0).toUpperCase() + word.slice(1)

  # $(".btn").on "click", ->
  #   $(@).addClass("btn-danger")

  array = [1,2,3,4,5]

  array.map (x)-> x * x

  eat = (x)->
    console.log "Eating #{x}"
  eat food for food in ["toast", "cheese", "wine"]

  
