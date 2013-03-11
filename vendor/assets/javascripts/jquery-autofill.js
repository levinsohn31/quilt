/*
* Auto-Fill Plugin
* Written by Joe Sak
* Website: http://www.joesak.com/
* Article: http://www.joesak.com/2008/11/19/a-jquery-function-to-auto-fill-input-fields-and-clear-them-on-click/
* GitHub: http://github.com/joemsak/jQuery-AutoFill
*/
/*
* This code has been altered for semantics by Andre, also has had defaultValue added as a feature
*/
(function($){
    $.fn.autofill=function(options){
	var defaults={
	    prompt:'First Name',
	    defaultValue:'',
	    promptTextColor:"#666",
	    activeTextColor:"#333"};


	var options=$.extend(defaults,options);
	return this.each(function(){
	    var obj=$(this);
	    var pfield = (obj.attr('type')=='password');
	    var p_obj = false;
      var activeElement;
	    if(pfield){ // second check is for reattaching to password fields
		obj.hide();
                if (obj.next().attr('id') != this.id + '_autofill') {
		    obj.after('<input type="text" id="'+this.id+'_autofill" class="'+$(this).attr('class')+'" />');
                }
		p_obj = obj;
		obj = obj.next();
	    }
	    try {
		       activeElement = document.activeElement; //ie9 throws an exception
	    } catch(e) {}
	    if(activeElement != obj[0]) {
		obj.css({color:options.promptTextColor})
		    .val(options.prompt);
                if(!pfield && options.defaultValue !== '') {
                    obj.css({color:options.activeTextColor})
                        .val(options.defaultValue);
                } else if (pfield && options.defaultValue && options.defaultValue !== '') {
                    obj.prev().val(options.defaultValue);
                    obj.prev().show();
                    obj.hide();
                }
	    }
	    obj.each(function() {
		$(this.form).submit(function() {
		    if (obj.val() == options.prompt) {
			obj.val('');
		    }
		});
	    });
	    obj.focus(function(){
		if(obj.val()==options.prompt){
		    if(pfield) {
			obj.hide();
			p_obj.show()
			    .focus();
		    }
		    obj.val('')
			.css({color:options.activeTextColor});
		}
	    });
            obj.focusout(function(){
		    if(obj.val() == ''){
			obj.css({color:options.promptTextColor})
			    .val(options.prompt);
		    }
		});
	    if(p_obj && p_obj.length > 0){
		p_obj.focusout(function(){
		    if(p_obj.val()==""){
			p_obj.hide();
			obj.show()
			    .css({color:options.promptTextColor})
			    .val(options.prompt);
		    }
		});
	    }
	});
    };
})(jQuery);
