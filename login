{% use 'giaodien.twig' %}
{% from 'func.twig' import d_get,d_add %}
{% from 'function.twig' import slug,auto,login %}

{% if login()|trim %}
{% include 'index' %}
{% else %}
 {{ block( 'header' ) }} 
 {% set url=get_uri_segments() %}
 <div class="phdr">Đăng Nhập</div>
 {# kiểm tra và lưu tài khoản #}
{% set user = get_post('user') %}
{% set pass = get_post('pass') %}
{% set cap= get_post('captcha') %}
{% if request_method()|lower == "post" %} 
{% if user and pass %}
{% if get_data_count('user_'~slug(user))==0 %}
<div class="menu">Tài khoản không tồn tại.</div>
{% else %}
{% if d_get('user_'~slug(user),'pass')!=pass%}
 <div class="menu">Mật khẩu không đúng.</div>
{% elseif cap==null %} 
 <div class="menu">Sai mã xác nhận!.</div>

{% else %}
 <div class="menu">Đăng nhập thành công.</div>
{% if get_post('auto')=='auto' %}
{% set auto=auto()|trim %}
{{ delete_data_by_id('auto_'~d_get('user_'~slug(user),'auto')|trim,get_data('auto_'~d_get('user_'~slug(user),'auto')|trim)|last.id) }}
 {% set save=save_data('auto_'~auto,''~slug(user)~'') %}
{{ d_add('user_'~slug(user),'auto',auto) }}
{{ set_cookie('auto',auto) }}
{% else %}
{{ set_cookie('auto',d_get('user_'~slug(user),'auto')|trim) }} 
{% endif %}
<script>window.location.href='/'</script>
{% endif %}
{% endif %}
{% else %}
<div class="menu"> Vui lòng điền đầy đủ thông tin.</div>
   {% endif %}
{% endif %} 
 <div class="menu"> 
<form method="post" action=""><i class="fa fa-user" aria-hidden="true"></i> <b>Tên tài khoản</b>:<br/><input type="text" name="user"><br/><i class="fa fa-lock" aria-hidden="true"></i> <b>Mật khẩu</b>:<br/> <input type="password"  name="pass">
<br/><i class="fa fa-key" aria-hidden="true"></i> <b>Mã bảo mật</b>: Trả lời câu hỏi<br/> <font color="red"> Gia đình bạn có biết bạn bị gay không? </font></br> <input type="text"  name="captcha">
<br/> <input type="checkbox" name="auto" value="auto">   Thay đổi autologin.<br /><input type="submit" name="submit" value="Đăng Nhập"></form></div>
{% set checkpass = d_get('bot','pass') %} 
{{block('footer')}}
{% endif %}