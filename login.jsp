<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<html>
<head>
<title>Knowledge Center</title>
<link rel="icon" href="images/igloo.ico" type="image/x-icon" />
<link rel="shortcut icon" href="images/igloo.ico" type="image/x-icon" />
<script type="text/javascript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; 
  if(d.images){ if(!d.MM_p) d.MM_p=new Array();
  var i,j=d.MM_p.length,a=MM_preloadImages.arguments; 
  for(i=0; i<a.length; i++)
  	if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; 
  for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  
  if(!d) d=document; 
  if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
  if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
	
function login() {
	var frm = document.loginForm;
	
	if(frm.id.value == "") {
		alert("ID를 입력하여 주십시오.");
		frm.id.focus();
		return ;
	}

	if(frm.passwd.value == "") {
		alert("패스워드를 입력하여 주십시오.");
		frm.passwd.focus();
		return ;
	}

	frm.method = "post";
	frm.action = "login_proc.jsp";
	frm.submit() ;
}

function keycheck() {
    if(event.keyCode == 13) {
		login();		
	}
}
//-->
</script>
</head>
<body leftmargin="0" topmargin="0" onLoad="MM_preloadImages('images/login_on.png'); document.loginForm.id.focus();">
<form name="loginForm">
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
    <tr>
    <td background="images/login_bg.png" valign="middle" align="center">
    <table width="453px" cellpadding="0" cellspacing="0">
    <tr><td style="padding:0px 0px 0px 12px;"><img src="images/ci.png" width="121" height="40"></td></tr><tr>
      <td background="images/login_backgroundimages.png" height="249" valign="top" style="padding:70px 50px 1px 200px;"><table width="150" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><input type="text" name="id" height="25" /></td>
        </tr>
        <tr>
          <td style="padding:18px 0px 0px 0px;"><input type="password" name="passwd" height="25" onkeydown="keycheck();"/></td>
        </tr>
        <tr>
          <td style="padding:30px 0px 0px 10px;"><img src="images/login.png" name="Image1" onclick="login();" hspace="0" vspace="0" id="Image1" onMouseOver="MM_swapImage('Image1','','images/login_on.png',1)" onMouseOut="MM_swapImgRestore()" /></td>
        </tr>
      </table></td></tr></table>
    </td>
    </tr>
</table>
</form>
</body>
</html>