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
   
  
    <link href="/cWeb/static/css/font-awesome.min.css" rel="stylesheet">
    <link href="/cWeb/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="/cWeb/static/css/templatemo-style.css" rel="stylesheet">
    <script type="text/javascript">
    	var s1_value=${m.categoryLevel1};
    	var s2_value=${m.categoryLevel2};
    	var s3_value=${m.categoryLevel3};
    	var m=0;
    	$(function(){
    		
    			bind1(0,"s1");
    			bind2(s1_value,"s2");
    			bind3(s2_value,"s3");
    			$("#s1").change(function(){
    				bind2($(this).val(),"s2");
    				$("#s3").html("");
    			});	
    			$("#s2").change(function(){
    				bind3($(this).val(),"s3");
    			});	
    	});
    
    	function bind1(pid,sid){
    		
				$.ajax({
					url:'/cWeb/appC/appCategory',
					type:'post',
					data:"pid="+pid,
					success:function(data){
						var str="";
							$(data).each(function(i,j){
								var value=j.categoryName;
								str=str+"<option value='"+j.id+"'>"+value+"</option>";
							});
							$("#"+sid).html(str);
							
						$("#"+sid).val(s1_value);
					}
				    
				});			
		   			
		   	}
		   	function bind2(pid,sid){
		   		
				$.ajax({
					url:'/cWeb/appC/appCategory',
					type:'post',
					data:"pid="+pid,
					success:function(data){
						var str="";
						
							$(data).each(function(i,j){
								var value=j.categoryName;
								if(i==0&&m!=0){
									md=j.id;
								}
								str=str+"<option value='"+j.id+"'>"+value+"</option>";
							});
							$("#"+sid).html(str);
					     if(m!=0){
					    	 $("#"+sid).val(md);
					     }else{
					    	 $("#"+sid).val(s2_value);
					     }
					}
				    
				});			
				
		}
		   	function bind3(pid,sid){
		   		
				$.ajax({
					url:'/cWeb/appC/appCategory',
					type:'post',
					data:"pid="+pid,
					success:function(data){
						var str="";
						
							$(data).each(function(i,j){
								var value=j.categoryName;
								if(i==0&&m!=0){
									md=j.id;
								}
								str=str+"<option value='"+j.id+"'>"+value+"</option>";
							});
							$("#"+sid).html(str);
							 if(m!=0){
						    	 $("#"+sid).val(md);
						     }else{
						    	 $("#"+sid).val(s3_value);
						    	 m=1;
						     }
							
					}
				    
				});			
				
		}
    
    </script>
</head>
<body>
	
        <jsp:include page="../frame/Header.jsp"></jsp:include>
       
		 <div class="templatemo-content-widget white-bg">
            <h2 class="margin-bottom-10">添加你的APP</h2>
			<form action="/cWeb/App/updateappinfo" class="templatemo-login-form" method="post" enctype="multipart/form-data">
            <!-- <form action="index.html" class="templatemo-login-form" method="post" enctype="multipart/form-data"> -->
              <div class="row form-group">
                <div class="col-lg-6 col-md-6 form-group">  
                	<input type="hidden" name="id" value="${m.id}"/>                
                    <label for="inputFirstName">版本名字</label>
                    <input type="text" class="form-control" name="softwareName" id="softwareName" value="${m.softwareName}" placeholder="John">                  
                </div>
                <div class="col-lg-6 col-md-6 form-group">                  
                    <label for="inputLastName">apk名字</label>
                    <input type="text" class="form-control" name="APKName" id="APKName" value="${m.APKName}" placeholder="Smith">                  
                </div> 
              </div>
			  
			   <div class="row form-group">
                <div class="col-lg-6 col-md-6 form-group">                  
                    <label for="inputFirstName">支持版本</label>
                    <input type="text" class="form-control" name="supportROM" id="supportROM" value="${m.supportROM}" placeholder="John">                  
                </div>
                <div class="col-lg-6 col-md-6 form-group">                  
                    <label for="inputLastName">语言</label>
                    <input type="text" class="form-control" name="interfaceLanguage" id="interfaceLanguage" value="${m.interfaceLanguage}"  placeholder="Smith">                  
                </div> 
              </div>
			  
			   <div class="row form-group">
                <div class="col-lg-6 col-md-6 form-group">                  
                    <label for="inputFirstName">一级分类</label>
                    <select name="categoryLevel1" class="form-control" id="s1">
					   
					</select> 
                </div>
                <div class="col-lg-6 col-md-6 form-group">                  
                    <label for="inputFirstName">二级分类</label>
                    <select name="categoryLevel2" class="form-control" id="s2">
					   
					</select> 
                </div>			
              </div>
			  
			   <div class="row form-group">
                <div class="col-lg-6 col-md-6 form-group">                  
                    <label for="inputFirstName">三级分类</label>
                    <select name="categoryLevel3"  class="form-control" id="s3">
					   
					</select> 
                </div>
                <div class="col-lg-6 col-md-6 form-group">                  
                    <label for="inputFirstName">图片</label>
                    <img width="30px" alt="未上传图片" src="/cWeb${m.logoPicPath}">
              		<img width="30px" alt="未上传图片" src="/cWeb${m.logoLocPath}">
                    <input type="file" name="AppImg" class="form-control" />
                    <input type="file" name="AppImg" class="form-control" />
                </div>			
              </div>

              <div class="form-group text-right">
                <button type="submit" class="templatemo-blue-button">修改</button>
                <button type="reset" class="templatemo-white-button">重置</button>
              </div>                           
            </form>
          </div> 
          <jsp:include page="../frame/Bottom.jsp"></jsp:include>
</body>
</html>