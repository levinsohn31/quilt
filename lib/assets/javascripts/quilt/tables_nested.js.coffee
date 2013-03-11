
  expandClick = (data) ->
    data.stopPropagation()
    if $(this).parents("li.nest-item").hasClass("expanded")
      $(this).parents("li.nest-item").removeClass "expanded"
    else
      $(this).parents("li.nest-item").addClass "expanded"
  
  if jQuery.fn.autofill
    $("li.nest-item.new input[name=description]").autofill
      prompt: "name/description"
      promptTextColor: "#666"
      activeTextColor: "#000"

  $("#new_record").click (data) ->
    data.stopPropagation()
    $("li.nest-item.new.expanded").show()
    $("#new_record").addClass "disabled"

  $("li.nest-item.new div.controls span.action").click (data) ->
    data.stopPropagation()
    li = $("li.nest-item.new.expanded")
    li.hide()
    li.find("input[type=checkbox]").removeAttr "checked"
    li.find("input[name=description]").val ""
    li.find("input[name=description]").focusout()
    $("#new_record").removeClass "disabled"

  $("li.nest-item.new form").submit (data) ->
    li = $("li.nest-item.new.expanded")
    input = li.find("input[name=description]")
    unless input.val()
      li.find("div.client_name").addClass "error"
      input.autofill
        prompt: "name is required"
        promptTextColor: "#A00"
        activeTextColor: "#000"

      input.focusout()
      return false
    else return false  if $("div.client_name.error").length > 0 and input.val() is "name is required"
    action = li.find("form").attr("action")
    formData = li.find("form").serialize()
    success = (data, textStatus, jqXHR) ->
      $("ul.nested_list li.nest-item.new").after "<li class=\"nest-item expanded\"></li>"
      li = $("li.nest-item.expanded").not(".new").first()
      data.expanded = true
      li.html $.mustache(showT, data)
      numElement = $("span.num_clients strong")
      numClients = parseInt(numElement.html())
      numElement.html numClients + 1
      $("li.nest-item.new div.controls span.action").click()
      attachClicks()

    $.ajax
      type: "POST"
      url: action
      data: formData
      success: success

    false

  showT = $("script#show").html()
  editT = $("script#edit").html()
  save = (data) ->
    parentLi = $(data.currentTarget).parents("li.nest-item.expanded")
    features = []
    parentLi.find("ul.pills li input:checked ~ label").map (index, item) ->
      features[index] = $(item).html().replace(/^\s+|\s+$/g, "")

    obj =
      client_id: parentLi.find("dd").html().replace(/^\s+|\s+$/g, "")
      client_secret: parentLi.find("dd").html().replace(/^\s+|\s+$/g, "")
      description: parentLi.find("input[name=description]").val().replace(/^\s+|\s+$/g, "")
      features: features

    obj.owner = parentLi.find("input[type=hidden]#" + obj.client_id + "_feature_owner").length is 1
    parentLi.html $.mustache(showT, obj)
    attachClicks()

  cancel = (data) ->
    parentLi = $(data.currentTarget).parents("li.nest-item.expanded")
    client_id = parentLi.find("dd").html().replace(/^\s+|\s+$/g, "")
    parentLi.html $("div#clean_" + client_id).html()
    attachClicks()

  editClick = (data) ->
    parentLi = $(data.currentTarget).parents("li.nest-item.expanded")
    features = parentLi.find("ul.pills li span").map((index, item) ->
      $(item).html().replace /^\s+|\s+$/g, ""
    )
    obj =
      client_id: parentLi.find("dd").html().replace(/^\s+|\s+$/g, "")
      client_secret: parentLi.find("dd").html().replace(/^\s+|\s+$/g, "")
      description: parentLi.find("span.description").html().replace(/^\s+|\s+$/g, "")
      owner: (parentLi.find("span.owner").length is 1)

    $("body").append "<div class=\"clean\" id=\"clean_" + obj.client_id + "\"></div>"
    $("div#clean_" + obj.client_id).html parentLi.html()
    parentLi.html $.mustache(editT, obj)
    parentLi.find("span.action").click cancel
    $(features).each (index, item) ->
      parentLi.find("input#" + obj.client_id + "_feature_" + item).attr "checked", "CHECKED"

    parentLi.find("form").submit (data) ->
      save data
      true

  deleteClick = (data) ->
    parentLi = $(data.currentTarget).parents("li.nest-item.expanded")
    client_id = parentLi.find("dd").html().replace(/^\s+|\s+$/g, "")
    if confirm("Are you sure?")
      $("form.delete").attr "action", deleteActionRoot + client_id
      $("form.delete").submit()

  deleteActionRoot = $("form.delete").attr("action")
  attachClicks = ->
    $("span.state").click expandClick
    $("input.button[value=Edit]").click editClick
    $("div.controls span.action.delete").click deleteClick
    $("li.nest-item").not("expanded").not("edit").not("new").click (data) ->
      data.stopPropagation()
      $(this).addClass "expanded"

  attachClicks()