<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%	
	String errCode = request.getParameter("code");
	String errMsg = "";
	
	int code = 0;
	try {
		code = Integer.parseInt(errCode);
	} catch(NumberFormatException e) {
		code = 0;
	}
	
	switch(code) {
	case HttpServletResponse.SC_UNAUTHORIZED : 
		errMsg = "인증된 사용자가 아니거나 세션이 종료 되었습니다."; 
		break;
	case HttpServletResponse.SC_BAD_REQUEST :
		errMsg = "접속 경로가 올바르지 않습니다.";
		break;
	default : errMsg = "Request Error";
	}
	
	String url = request.getHeader("Referer");
	if(url == null) {
		url = "#";
	}
	else {
		url = "/";
	}
	
	/** Info page를 따로 생성????
	int i = url.indexOf("/extrim");
	if(i > 0) {
		int n = url.indexOf("?");
		if(n < 0)
			url = url.substring(i);
		else
			url = url.substring(i, n);
	}
	*/
%>
<html>
<head>
<title>Knowledge Center</title>
<link rel="icon" href="images/igloo.ico" type="image/x-icon" />
<link rel="shortcut icon" href="images/igloo.ico" type="image/x-icon" />
<script type="text/javascript">
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
</script>
</head>

<body leftmargin="0" topmargin="0" onLoad="MM_preloadImages('../images/error/cencel_on.png','../images/error/ok_on.png')">
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
    <tr>
    <td valign="middle" align="center">
    <table width="459px" cellpadding="0" cellspacing="0">
      <tr>
        <td style="padding:0px 0px 0px 12px;"><img src="../images/error/ci.png" width="121" height="41"></td>
      </tr>
      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="30"><img src="../images/error/error_box_1_01.png" width="30" height="30"></td>
              <td background="../images/error/error_box_1_02.png">&nbsp;</td>
              <td width="30"><img src="../images/error/error_box_1_03.png" width="34" height="30"></td>
            </tr>
            <tr>
              <td background="../images/error/error_box_1_04.png">&nbsp;</td>
              <td>
              <table width="100%" height="200" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="145"><img src="../images/error/error_icon.png" width="145" height="147" ></td>
                  <td valign="top">
                    <p><h3><%= errCode %></h3></p>
                    <p><%= errMsg %></p>
                    <br>
                    <br>
                    <br>
                    <br>
                      
                    <!--
                    <img src="../images/error/cencel.png" width="85" height="20" id="Image1" onMouseOver="MM_swapImage('Image1','','../images/error/cencel_on.png',1)" onMouseOut="MM_swapImgRestore()"> 
                    -->
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <img src="../images/error/ok.png" onclick="javascript:location.href='<%= url %>';" width="85" height="20" id="Image2" onMouseOver="MM_swapImage('Image2','','../images/error/ok_on.png',1)" onMouseOut="MM_swapImgRestore()"> 
                    
                  </td>
                </tr>
              </table>
              </td>
              <td background="../images/error/error_box_1_06.png">&nbsp;</td>
            </tr>
            <tr>
              <td><img src="../images/error/error_box_1_07.png" width="30" height="32"></td>
              <td background="../images/error/error_box_1_08.png">&nbsp;</td>
              <td><img src="../images/error/error_box_1_09.png" width="34" height="32"></td>
            </tr>
          </table>
          </td>
      </tr>
    </table>
    </td>
    </tr>
</table>
</body>
</html>
