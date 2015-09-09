$ ->
  $("#click-me").on "click", ->
    if $(@).hasClass("btn-danger")
      $(@).removeClass("btn-danger")
    else
      $(@).addClass("btn-danger")

  capEachWord = (sentence) ->
    words = sentence.split(" ")
    words = words.map (word)->
              word.charAt(0).toUpperCase() + word.slice(1)
    words.join " "

  $("#cap-each").on "keyup", ->
    # document.getElementById("text").textContent = $(@).val()
    caps = capEachWord $(@).val()
    $("#text").html caps
