---
title: openresty lua api
date: 2020-05-09
private: true
---
# openresty lua api
待整理https://www.infvie.com/ops-notes/ngx-lua-api.html
![](/img/openresty/lua-api.png)


# API指令
    lua_code_cache on | off;

    作用:打开或关闭Lua代码缓存，影响以下指令:set_by_lua_file,content_by_lua_file,rewrite_by_lua_file, access_by_lua_file及强制加载或者reload Lua模块等。缓存开启时修改LUA代码需要重启nginx，不开启时则不用。开发阶段一般关闭缓存。

    作用域：main，server，location，location if

    lua_regex_cache_max_entries 1024;

    作用:未知(貌似是限定缓存正则表达式处理结果的最大数量)

    lua_package_path …/path…;

    作用:设置用lua代码写的扩展库路径。

    例子:lua_package_path ‘/foo/ba版权声明：本文遵循 CC 4.0 BY-SA 版权协议，若要转载请务必附上原文出处链接及本声明，谢谢合作！r/?.lua;/blah/?.lua;;’;

    lua_package_cpath ‘/bar/baz/?.so;/blah/blah/?.so;;’;

    作用:设置C扩展的lua库路径。

    set_by_lua $var ‘<lua-script>’ [$arg1 $arg2];

    set_by_lua_file $var 版权声明：本文遵循 CC 4.0 BY-SA 版权协议，若要转载请务必附上原文出处链接及本声明，谢谢合作！<path-to-lua-script-file> [$arg1 $arg2 …];

    作用:设置一个nginx变量，变量值从lua脚本里运算由return返回，可以实现复杂的赋值逻辑;此处是阻塞的，Lua代码要做到非常快。

    另外可以将已有的ngx变量当做参数传进Lua脚本里去，由ngx.arg[1],ngx.arg[2]等方式访问。

    作用域:main, server,location,server if, location if

    处理阶段:rewrite.

    content_by_lua ‘<lua script>’;

    content_by_lua_file luafile;

    作用域:location，location if

    说明:内容处理器，接收请求处理并输出响应，content_by_lua直接在nginx配置文件里编写较短Lua代码后者使用lua文件。

    rewrite_by_lua ‘<lua script>’

    rewrite_by_lua_file lua_file;

    作用域:http, server, location, location if

    执行内部URL重写或者外部重定向，典型的如伪静态化的URL重写。其默认执行在rewrite处理阶段的最后。

    注意，在使用rewrite_by_lua时，开启rewrite_log on;后也看不到相应的rewrite log。

    ac版权声明：本文遵循 CC 4.0 BY-SA 版权协议，若要转载请务必附上原文出处链接及本声明，谢谢合作！cess_by_lua ‘lua code’;

    access_by_lua_file lua_file.lua;

    作用:用于访问控制，比如我们只允许内网ip访问，可以使用如下形式。

    access_by_lua ‘

    if ngx.req.get_uri_args()[“token”] ~= “123” then

        return ngx.exit(403)

    end’;

    作用域: http, server, location, location if

    header_filter_by_lua ‘lua code’;

    header_filter_by_lua_file path_file.lua;

    作用:设置header和cookie;

    lua_need_request_body on|off;

    作用:是否读请求体，跟ngx.req.read_body()函数作用类似，但官方不推荐使用此方法。

    lua_shared_dict shared_data 10m;

    作用:设置一个共享全局变量表，在所有worker进程间共享。在lua脚本中可以如下访问它:

    例:local shared_data = ngx.shared.shared_data;

    init_by_lua ‘lua code’;

    init_by_lua_file lua_file.lua;

    作用域:http

    说明:ginx Master进程加载配置时执行;通常用于初始化全局配置/预加载Lua模块

    init_worker_by_lua ‘lua code’;

    init_worker_by_lua_file luafile.lua;

    作用域:http

    说明:ginx Master进程加载配置时执行;通常用于初始化全局配置/预加载Lua模块

    init_worker_by_lua ‘lua code’;

    init_worker_by_lua_file luafile.lua;

    作用域:http

    说明:每个Nginx Worker进程启动时调用的计时器，如果Master进程不允许则只会在init_by_lua之后调用;通常用于定时拉取配置/数据，或者后端服务的健康检查。

# API常量
 
    ngx.arg[index]    #ngx指令参数，当这个变量在set_by_lua或者set_by_lua_file内使用的时候是只读的，指的是在配置指令输入的参数。
    ngx.var.varname    #读写NGINX变量的值，最好在lua脚本里缓存变量值，避免在当前请求的声明周期内内存的泄露
    ngx.config.ngx_lua_version   #当前ngx_lua模块的版本号
    ngx.config.nginx_version   #nginx版本
    ngx.worker.exiting    #当前worker进程是否正在关闭
    ngx.worker.pid    #当前worker进程的PID
    ngx.config.nginx_configure #编译时的./configure命令选项
    ngx.config.prefix    #编译时的prefix选项
    
    core constans:      #ngx_lua核心常量
        ngx.OK (0)
        ngx.ERROR (-1)
        ngx.AGAIN (-2)
        ngx.DONE (-4)
        ngx.DECLINED (-5)
        ngx.nil
    http method constans:   #进程在ngx.location.catpure和ngx.location.capture_multi方法中被调用。
        ngx.HTTP_GET
        ngx.HTTP_HEAD
        ngx.HTTP_PUT
        ngx.HTTP_POST
        ngx.HTTP_DELETE
        ngx.HTTP_OPTIONS
        ngx.HTTP_MKCOL
        ngx.HTTP_COPY
        ngx.HTTP_MOVE
        ngx.HTTP_PROPFIND
        ngx.HTTP_LOCK
        ngx.HTTP_UNLOCK
        ngx.HTTP_PATCH
        ngx.HTTP_TRACE
    http status constans:    #http请求状态常量
        ngx.HTTP_OK  (200)
        ngx.HTTP_CREATED (201)
        ngx.HTTP_SPECIAL_RESPONSE (300)
        ngx.HTTP_MOVED_PERMANENTLY (301)
        ngx.HTTP_MOVED_TEMPORARILY (302)
        ngx.HTTP_SEE_OTHER (303)
        ngx.HTTP_NOT_MODIFIED (304)
        ngx.HTTP_BAD_REQUEST (400)
        ngx.HTTP_UNAUTHORIZED (401)
        ngx.HTTP_FORBIDDEN (403)
        ngx.HTTP_GONE (404)
        ngx.HTTP_NOT_ALLOWED (405)
        ngx.HTTP_GONE (410)
        ngx.HTTP_INTERNAL_SERVER_ERROR (500)
        ngx.HTTP_METHOD_NOT_IMPLEMENTED (501)
        ngx.HTTP_SERVICE_UNAVAILABLE (503)
        ngx.HTTP_GATEWAY_TIMEOUT (504)
    
    Nginx log level constants:      #错误日志级别常量，这些参数经常在ngx.log方法中被使用。
        ngx.STDERR
        ngx.EMERG
        ngx.ALERT
        ngx.CRIT
        ngx.ERR
        ngx.WARN
        ngx.NOTICE
        ngx.INFO
        ngx.DEBUG
# API方法
```lua
    print()               #与ngx.print()方法有区别，print()相当于ngx.log()
    ngx.ctx               #这是一个lua的table，用于保存ngx上下文的变量，在整个请求的生命周期内都有效，详细参考官方
    ngx.location.capture()    #发出一个子请求，详细用法参考官方文档。
    ngx.location.capture_multi()  #发出多个子请求，详细用户参考官方文档。
    ngx.status                #读或者写当前请求的相应状态，必须在输出相应头之前被调用。
    ngx.header.HEADER     #访问或设置http header头信息，详细参考官方文档
    ngx.req.set_uri()    #设置当前请求的URI，详细参考官方文档
    ngx.set_uri_args(args)   #根据args参数重新定义当前请求的URI参数。
    ngx.req.get_uri_args()   #返回一个LUA TABLE,包括所有当前请求的URL参数
    ngx.req.get_post_args()  #返回一个LUA TABLE,包括所有当前请求的POST参数
    ngx.req.get_headers()    #返回一个包含当前请求头信息的lua table.
    ngx.req.set_header()     #设置当前请求头header某字段值。当前请求的子请求不会受到影响。
    ngx.req.read_body()      #在不阻塞nginx其他事件的情况下同步读取客户端的body信息[详细]
    ngx.req.discard_body()   #明确丢弃客户端请求的body.
    ngx.req.get_body_data()   #以字符串的形式获得客户端的请求body内容
    ngx.req.get_body_file()  #当发送文件请求的时候，获得文件的名字
    ngx.req.set_body_data()  #设置客户端请求的BODY
    ngx.req.clear_header()   #请求某个请求头
    ngx.exec(uri, args)      #执行内部跳转，根据uri和请求参数
    ngx.redirect(uri, args)  #执行301或者302的重定向。
    ngx.send_headers()       #发送指定的响应头
    ngx.headers_sent         #判断头部是否发送给客户端ngx.headers_sent=true
    ngx.print(str)           #发送给客户端的响应页面
    ngx.say()                #作用类似ngx.print,不过say方法输出后会换行
    ngx.log(log.level, ...)   #写入nginx日志
    ngx.flush()            #将缓冲区内容输出到页面(刷新响应)
    ngx.exit(http-status)   #结束请求并输出状态码
    ngx.eof()               #明确指定关闭结束输出流
    ngx.escape_uri()        #将URI编码(本函数对逗号，不编码，而php的uriencode会编码)
    ngx.unescape_uri()     #将uri解码
    ngx.encode_args(table)   #将table解析成url参数
    ngx.decode_args(uri)     #将参数字符串编码为一个table
    ngx.encode_base64(str)    #BASE64编码
    ngx.decode_base64(str)    #BASE64解码
    ngx.crc32_short(str)      #字符串的crs32_short哈希
    ngx.crc32_long(str)       #字符串的crs32_long哈希
    ngx.md5(str)              #返回16进制MD5
    ngx.md5_bin(str)          #返回2进制MD5
    ngx.today()               #返回当前日期yyyy-mm-dd
    ngx.time()                #返回当前时间戳
    ngx.now()                 #返回当前时间
    ngx.update_time()         #刷新后返回
    ngx.localtime()           #返回yyyy-mm-dd hh:ii:ss
    ngx.utctime()             #返回yyyy-mm-dd hh:ii:ss格式的utc时间
    ngx.cookie_time(src)      #返回可用于http header使用的时间
    ngx.parse_http_time(str)  #解析HTTP头的时间
    ngx.is_subrequest         #是否子请求(值为true or false)
    ngx.re.match(subject, regex, options, ctx)   #ngx正则表达式匹配，详细参考官网
    ngx.re.gmatch(subject, regex, opt)      #全局正则匹配
    ngx.re.sub(sub, reg, opt)     #匹配和替换(未知)
    ngx.re.gsub()                 #未知
    ngx.shared.DICT               #ngx.shared.DICT是一个table里面存储了所有的全局内存共享变量
        ngx.shared.DICT.get
        ngx.shared.DICT.get_stale
        ngx.shared.DICT.set
        ngx.shared.DICT.safe_set
        ngx.shared.DICT.add
        ngx.shared.DICT.safe_add
        ngx.shared.DICT.replace
        ngx.shared.DICT.delete
        ngx.shared.DICT.incr
        ngx.shared.DICT.flush_all
        ngx.shared.DICT.flush_expired
        ngx.shared.DICT.get_keys
    ndk.set_var.DIRECTIVE         #允许调用nginx C 模块指令
```

# openresty opm 包管理
自1.11.2.2开始，OpenResty版本已经包含并默认安装opm。所以通常你不需要自己安装opm ， 只需要做一个软连接 。附：踩坑之旅

    cd /usr/local/openresty/bin
    sudo ln -s `pwd`/opm /usr/local/bin/opm
    
    opm search 包名  #搜索包名
    opm get 包名 #默认下载路径：/usr/local/openresty/site/lualib/resty
    
    #规范包安装目录
    /usr/local/openresty/lualib/resty
    #正确安装方法：
    opm --install-dir=/usr/local/openresty get 包名

# 参考文献
https://github.com/openresty/lua-nginx-module#locations-configured-by-subrequest-directives-of-other-modules
https://github.com/iresty/nginx-lua-module-zh-wiki