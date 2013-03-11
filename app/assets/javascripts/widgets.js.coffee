$(".radio-desktop input").click ->
  $(".radio-desktop input:checked").add("janrain-capture-ui").add("div.janrain-capture-ui-mobile-landscape").add("div.janrain-capture-ui-mobile-portrait").removeClass("janrain-capture-ui-mobile-portrait").removeClass("janrain-capture-ui-mobile").removeClass "janrain-capture-ui-mobile-landscape"

$(".radio-mobile-portrait input").click ->
  $(".radio-mobile-portrait input:checked").add("div.janrain-capture-ui-mobile-landscape").add("div.janrain-capture-ui").addClass("janrain-capture-ui-mobile janrain-capture-ui-mobile-portrait").removeClass "janrain-capture-ui-mobile-landscape"

$(".radio-mobile-landscape input").click ->
  $(".radio-mobile-landscape input:checked").add("div.janrain-capture-ui-mobile-portrait").add("div.janrain-capture-ui").addClass("janrain-capture-ui-mobile janrain-capture-ui-mobile-landscape").removeClass "janrain-capture-ui-mobile-portrait"
