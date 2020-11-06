<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="viewport"
	      content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"/>
	<title>AppInfoList</title>
	<script type="text/javascript" src="/cWeb/static/js/jquery-1.11.2.min.js"></script>      <!-- jQuery -->
    <script type="text/javascript" src="/cWeb/static/js/templatemo-script.js"></script>      <!-- Templatemo Script -->
    <script type="text/javascript">
	    $(function(){
	    	delback();
	    });
    	function search(){
    		window.location="/cWeb/App/appinfolist?index=1&appName="+$("#softwareName").val();
    	}
    	function delback(){
			var ss="";
			ss+="${pnum}";
	    	if(ss!=""&&ss!=null){
	    		alert("${info}");
	    		ss
	    	}else{
	    		
	    	}
    	}
    	
    </script>
  
    <link href="/cWeb/static/css/font-awesome.min.css" rel="stylesheet">
    <link href="/cWeb/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="/cWeb/static/css/templatemo-style.css" rel="stylesheet">
</head>
<body>
	
        <jsp:include page="../frame/Header.jsp"></jsp:include>
		  <div class="form-group">
		    <label for="name">模糊查询:</label>
		    <input type="text" class="form-control" name="softwareName" id="softwareName" value="${appName}"  placeholder="请输入App名称" style="display:inline;width:25%;height:34px;">
		    <input type="button" class="btn btn-default" onclick="search()" value="搜索">
		  </div>
		  
            <div class="panel panel-default table-responsive">
              <table class="table table-striped table-bordered templatemo-user-table">
                <thead>
                  <tr>
                    <td><a href="" class="white-text templatemo-sort-by">编号 <span class="caret"></span></a></td>
                    <td><a href="" class="white-text templatemo-sort-by">软件名称 <span class="caret"></span></a></td>
                    <td><a href="" class="white-text templatemo-sort-by">APK名称 <span class="caret"></span></a></td>
                    <td><a href="" class="white-text templatemo-sort-by">LOGO图片1<span class="caret"></span></a></td>
                    <td><a href="" class="white-text templatemo-sort-by">LOGO图片2 <span class="caret"></span></a></td>
                    <td>App类型</td>
                    <td>Edit</td>
                    <td>Action</td>
                    <td>Delete</td>
                  </tr>
                </thead>
                <tbody>
                	<c:forEach items="${ll}" var="al">
                		<tr>
		                    <td>${al.id}</td>
		                    <td>${al.softwareName}</td>
		                    <td>${al.APKName}</td>
		                    <td><img width="100px" alt="无图片" src="/cWeb${al.logoPicPath}"></td>
		                    <td><img width="100px" alt="无图片" src="/cWeb${al.logoLocPath}"></td>
		                    <td>${al.dev}</td>
		                    <td><a href="/cWeb/App/appinfolistforupdate/tr_3b_${al.id}_dd" class="templatemo-edit-btn">Edit</a></td>
		                    <td><a href="" class="templatemo-link">Action</a></td>
		                    <td><a href="/cWeb/App/deleteappinfo/tt_1o_${al.id}_6t" class="templatemo-edit-btn">Delete</a></td>
		                 </tr>
                	</c:forEach>             
                </tbody>
              </table>    
            </div>                          
          </div>          
       
       
          <div class="pagination-wrap">
            <ul class="pagination">
            	<c:forEach begin="1" end="${count}" var="i">
              		<li><a href="/cWeb/App/appinfolist?index=${i}&appName=${appName}">${i}</a></li>
             	</c:forEach>   
              <!-- <li>
                <a href="#" aria-label="Next">
                  <span aria-hidden="true"><i class="fa fa-play"></i></span>
                </a>
              </li> -->
            </ul>
          </div>          
          <jsp:include page="../frame/Bottom.jsp"></jsp:include>
</body>
</html>