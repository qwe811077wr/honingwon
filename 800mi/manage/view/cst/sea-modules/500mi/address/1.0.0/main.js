define(function(require){function i(){var e={method:"Add",name:t(".searchForm input[name='name']").val(),province:"浙江省",city:t(".searchForm select[name='city']").val(),district:t(".searchForm select[name='district']").val(),addr:t(".searchForm textarea[name='street']").val(),contacts:"联系方式???",phone:t(".searchForm input[name='phone']").val()};OP=="edit"&&(e.method="edit",e.storeId=t(".searchForm input[name='id']").val()),t.ajax({type:"post",url:"/view/model/BMManage/StoreManageMethod.php",dataType:"json",data:e,success:function(e){e.Success?(OP=="edit"?alert("编辑成功"):alert("添加成功"),window.location.href="/view/cst/myaddress.php"):alert("添加失败")},error:function(e){alert("链接错误")}})}require("common"),require("cart");var e=require("underscore"),t=require("$"),n=require("validator"),r=new n({element:"#form"});r.addItem({element:"#name",required:!0,display:"门店名称"}).addItem({element:"#city",required:!0,display:"城市名称"}).addItem({element:"#district",required:!0,display:"区/县名称",showMessage:function(e,n){var r=t.trim(this.getExplain(n).html());r||(this.getExplain(n).html(e),this.getItem(n).addClass(this.get("itemErrorClass")))},hideMessage:function(e,n){var r=t.trim(this.getExplain(n).html());r||(this.getExplain(n).html(n.attr("data-explain")||" "),this.getItem(n).removeClass(this.get("itemErrorClass")))}}).addItem({element:"#street",required:!0,display:"街道地址"}).addItem({element:"#phone",required:!0,display:"手机号码"}),t('button[type="submit"]').bind("click",function(){return r.execute(function(e,t,n){e||i()}),!1}),t.ajax({type:"get",url:"/view/model/BMManage/StoreManageMethod.php",dataType:"json",data:{method:"List"},success:function(e){console.log(e);if(e.Success){var n="",r=e.DataList,i;for(var s=0;s<r.length;s++)i=r[s],n+='<tr class="'+(s%2==1?"even":"")+'">',n+="</tr>",n+="<td>"+i.shop_name+"</td>",n+="<td>"+i.shop_city+i.shop_district+"</td>",n+="<td>"+i.shop_addr+"</td>",n+="<td>"+i.shop_phone+"</td><td></td>",n+='<td class="t-operate"><a href="/view/cst/myaddress.php?op=edit&id='+i.shop_id+"&name="+i.shop_name+"&street="+i.shop_addr+"&phone="+i.shop_phone+'">修改</a>|<a class="delete" href="javascript:address.deleteItem('+i.shop_id+');">删除</a></td>';t("#addressList").html(n)}},error:function(e){alert("链接错误")}});var s={};s.deleteItem=function(e){t.ajax({type:"post",url:"/view/model/BMManage/StoreManageMethod.php",dataType:"json",data:{method:"Del",storeId:e},success:function(e){e.Success?(alert("删除成功"),window.location.href="/view/cst/myaddress.php"):alert("删除失败")},error:function(e){alert("链接错误")}})},window.address=s})