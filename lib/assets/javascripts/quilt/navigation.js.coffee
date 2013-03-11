$("html").click ->
  $("li.dropdown").removeClass "selected"

$(".main_nav li a,.global_nav li a").click ->
  $this = $(@parentNode)
  if $this.is(".selected")
    $this.removeClass "selected"
  else
    $this.removeClass "selected"
    $this.addClass "selected"
    $this.siblings().removeClass "selected"

$(".main_nav li.dropdown a.dropdown-item,.global_nav li.dropdown a.dropdown-item").click ->
  $this = $(this)
  if $this.is(".selected")
    $this.removeClass("selected").removeClass "active"
    $this.addClass "none"
  else
    $this.removeClass("none").removeClass "active"
    $this.addClass("selected").addClass "active"
    $this.siblings().removeClass("selected").removeClass "active"
  false

$(".select").find(".select-label").click ->
  $this = undefined
  $this = $(@parentNode)
  if $this.is(".selected")
    $this.removeClass "selected"
  else
    $this.removeClass "selected"
    $this.addClass "selected"
    $this.siblings().removeClass "selected"
  false

$(".steps li").click ->
  $this = $(this)
  if $this.is(".active")
    $this.removeClass "active"
  else
    $this.removeClass "active"
    $this.addClass "active"
    $this.siblings().removeClass "active"
  false

$(".pills li a").click ->
  $this = $(@parentNode)
  if $this.is(".active")
    $this.removeClass "active"
  else
    $this.removeClass "active"
    $this.addClass "active"
    $this.siblings().removeClass "active"
  false

$(".accordion-item .title").click ->
  $this = $(@parentNode)
  if $this.is(".active")
    $this.removeClass "active"
    $this.children ".accordion-info"
  else
    $this.removeClass "active"
    $this.addClass "active"
    $this.siblings().removeClass "active"
    $this.children ".accordion-info"
  false

$(".list li").click ->
  $this = $(this)
  if $this.is(".active")
    $this.removeClass "active"
  else
    $this.removeClass "active"
    $this.addClass "active"
    $this.siblings().removeClass "active"
  

$(".radio_box input").val ->
  $(this).parent().addClass "dark"  if $(this).is(":checked")

$(".radio_box input").change ->
  if $(this).is(":checked")
    $(this).parent().parent().find(".dark").removeClass "dark"
    $(this).parent().addClass "dark"



$(".data").delegate "a", "mouseover mouseleave", (e) ->
  if e.type is "mouseover"
    $(this).parent().parent().addClass "hover"
  else
    $(this).parent().parent().removeClass "hover"


$("#slider").keyup()

if jQuery.fn.miniColors
  $("#minicolor").miniColors()

if jQuery.ui
  $(".tabs").tabs fx:
    opacity: "toggle"
    duration: "fast"
  $("#slider_ui").slider()