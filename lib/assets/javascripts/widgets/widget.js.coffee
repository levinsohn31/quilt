$(".radio-styled").click ->
  check = $(this).find("input[type=radio]")
  if $(check).is(":checked")
    $(check).attr "checked", ""
  else
    $(check).attr "checked", "checked"

$(".capture_radio_box input:checked").addClass "capture_toggled"
$(".capture_radio_box label").click ->
  $(".capture_radio_box input").click ->
    $(".capture_radio_box input:not(:checked)").parent().removeClass "capture_toggled"
    $(".capture_radio_box input:checked").parent().addClass "capture_toggled"

$(".checkbox").click ->
  check = $(this).find("input[type=checkbox]")
  if $(check).is(":checked")
    $(check).attr "checked", ""
  else
    $(check).attr "checked", "checked"

$(".user-tools").click ->
  $(".popup-bubble").toggle()