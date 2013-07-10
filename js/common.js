

function trace(isTrace, s) {
  try { 
	  if(isTrace > 0) {
		  console.log(s); 
	  }
  } catch (e) { 
	  //alert(s); 
  }
}

function objectToString(o){
    var parse = function(_o){
        var a = [], t;
        for(var p in _o){
            if(_o.hasOwnProperty(p)){
                t = _o[p];
                if(t && typeof t == "object"){
                    a[a.length]= p + ":{ " + arguments.callee(t).join(", ") + "}";
                }
                else {
                    if(typeof t == "string"){
                        a[a.length] = [ p+ ": \"" + t.toString() + "\"" ];
                    }
                    else{
                        a[a.length] = [ p+ ": " + t.toString()];
                    }
                }
            }
        }
        
        return a;
    }
    
    return "{" + parse(o).join(", ") + "}";
}

function cutStr(str, num){
	var ret="";
	var i;
	var msglen = 0;
	for(i = 0; i < str.length; i++){
        var ch = str.charAt(i);
		if(escape(ch).length > 4){
			msglen += 2;
	   	}
		else{
	   		msglen++;
		}
		if(msglen > num){
			break;
		} 
		ret += ch;
	}
	if(ret.length != str.length){
		ret += "...";
	}
	return ret;
}

function alertMsg(form, msg, option) {
	var width = option == undefined ? "300" : option.width;
	var height = option == undefined ? "auto" : option.height;
	var titlespan = "<span class='ui-icon ui-icon-alert' style='float:left;'></span>&nbsp;";
	var title = option == undefined ? titlespan + "메세지" : titlespan + option.title;
	$("#alertMessage").dialog({
        autoOpen: false,
        resizable: false,
    	modal: true,
    	width : width,
    	height : height,
    	top:"auto",
    	buttons: {
    		"닫기": function() {
    		    if (form.length > 0 && msg.split("#").length > 0) {
    		        $(form).find("#" + msg.split("#")[0]).trigger("focus");
    		    }
    		    $(this).dialog("destroy");
    		}
    	}
    });
	
    $("#alertMessage").dialog("open");
    if (form.length > 0 && msg.split("#").length > 0) {
        $("#alertMessageText").html(msg.split("#")[1]);
    }
    else {
        $("#alertMessageText").html(msg);
    }
    $("#alertMessage").dialog("option", "title", title);
}

function confirmMsg(msg, ok) {
    $("#confirmMessage").dialog({
        autoOpen: false,
        resizable: false,
    	modal: true,
    	buttons: {
    		"확인": ok,
    		"취소": function() {
    		    $("#confirmMessage").dialog("close");
    		}
    	},
    });
    $("#confirmMessage").dialog("open");
    $("#confirmMessageText").html(msg);
}
