$(document).ready(function() {
    if(jQuery.fn.mask){
     $.mask.definitions['~'] = '[+-]';
    }
    TABLES = {};

    // v utilities
    TABLES.name_to_id = function(name) {
        var html_id = '';
        html_id = name.replace(/\[/g, '_');
        return html_id.replace(/\]/g, '');
    };
    // ^ utilities

    $('ul.editable_block').click(function(data) {
        data.stopPropagation();

        $(this).toggleClass('collapsed');
        $(this).children().not(':first').toggle();
    });
    $('ul li').click(function(data) {
        data.stopPropagation();
    });
    $('ul.editable_block').hover(function() {
        // to do: draw a link for editing the block
    });

    TABLES.update_attr = function(){
        //remove all other elements
        var this_form = $(this).closest('li').find('>.form_items');
        var other_fields = $('.form_items').not(this_form);
        other_fields.each(function(index) {
            var cancel_link = $(this).find('a.cancel');
            TABLES.cancel_edit($(cancel_link[0]));
        });
    };

    TABLES.cancel_edit = function(my_link) {
        var parentLi = $(this).closest('li');
        if (parentLi.length === 0) { parentLi = $(my_link).closest('li'); }
        parentLi.find('>.row').show();
        parentLi.find('>.form_items').remove();
        return false;
    };

    //cancel edit form
    $('a.cancel.edit').click(TABLES.cancel_edit);

    // show edit form
    $('div.record.edit li span.row.editable').click(function() {
         var html_id, options, type, obj, editT, rowCount, inputName,
             value, pluralId, update_attr_button;
         parentLi = $(this).closest('li');
         if (parentLi.find('span.title').attr('attr_type') === 'plural') {
            return false;
         }
         type = parentLi.find('span.row span.value').attr('attr_type');
         if (type === null) { type = 'string'; }
         //password type is password-crypt-256 which doesn't read well in this context
         if (type.indexOf('password') !== -1) { type = 'password'; }
         editT = $('#attributes_edit_' + type).html();
         //make sure edit form can be created
         if (editT === null) { editT = $('#attributes_edit_string').html(); }
         inputName = parentLi.find('span.row span.value').attr('input_name');
         pluralId = parentLi.closest('ul').find('>li span.title').text();
         key = parentLi.find('>.row span.name').text();
         value = parentLi.find('span.row span.value').html();

         //to determine to show text input or textarea?
         rowCount = function() {
              var lineHeightPx, heightPx, rowCount;
              lineHeightPx = parseFloat(parentLi.find('.row span.name').height());
              heightPx = parentLi.height();
              rowCount = Math.floor(heightPx/lineHeightPx);
              if (rowCount <= 1) { rowCount = 0; }
              return rowCount;
         }();
         if (type === 'boolean' && value === 'true') {
             options = [{value: true, selected: true}, {value: false}];
         } else {
             options = [{value: true}, {value: false, selected: true}];
         }
         if (type === 'date' || type === 'dateTime') {
             html_id = TABLES.name_to_id(inputName);
         }
         obj = {
             plural_id: pluralId,
             input_name: inputName,
             key: key,
             value: value,
             row_count: rowCount,
             options: options,
             html_id: html_id,
             attr_type: type
        }
        parentLi.find('.row').hide();
        parentLi.append($.mustache(editT, obj));
        $('textarea.setting_value', parentLi).focus();
        $('input.setting_value', parentLi).focus();

        if (type === 'date') {
            $('#' + html_id).mask("9999-99-99");
        } else if (type === 'dateTime') {
            $('#' + html_id).mask("9999-99-99 99:99?:99 ~9999");
        }
        //attach clicks
        $('a.cancel.edit', parentLi).click(TABLES.cancel_edit);
        update_attr_button = $('input.edit.update.attr.button', parentLi);
        update_attr_button.click(TABLES.update_attr);
        $('input', parentLi).keypress(function(e){
        if ( e.which == 13 ) {
            return false;
        }
      });
    });

    //history
    $('.history ul#versions a.more').click(function() {
        var thisLi = $(this).closest('li');
        thisLi.next().removeClass('hidden');
        $(this).addClass('hidden');
        return false;
    });
    //toggle history view
    $('.history h2 a.toggle_view').click(function() {
        $(this).closest('.history').find('ul#versions').toggle();
        $(this).toggle();
        $(this).siblings().toggle();
        return false;
    });
});

