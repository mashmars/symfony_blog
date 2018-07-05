-- phpMyAdmin SQL Dump
-- version 4.7.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: 2018-07-05 22:24:52
-- 服务器版本： 5.5.56-log
-- PHP Version: 7.1.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `symfony_blog`
--

-- --------------------------------------------------------

--
-- 表的结构 `article`
--

CREATE TABLE `article` (
  `id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descript` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thumb` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `category_id` int(11) DEFAULT NULL,
  `views` int(11) DEFAULT NULL,
  `is_comment` tinyint(1) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 转存表中的数据 `article`
--

INSERT INTO `article` (`id`, `title`, `descript`, `thumb`, `created_at`, `updated_at`, `content`, `category_id`, `views`, `is_comment`, `status`) VALUES
(1, 'symfony4如何使用分页功能', 'symfony中通过knp组件实现分页', NULL, '2018-07-04 14:00:53', NULL, '为了记录symfony4的学习过程，首先准备了后台的文章管理系统，通过一系列的准备工作，比如选择编辑器等；另外就是先解决文章的分页功能，在这儿通过使用knp分页组件完成；<blockquote>composer require &quot;knplabs/knp-paginator-bundle&quot; &nbsp;</blockquote><blockquote><code>$qb</code> <code>=&nbsp;</code><code>$em</code><code>-&gt;getRepository(</code><code>&#39;AppBundle:DemoList&#39;</code><code>)-&gt;createQueryBuilder(</code><code>&#39;u&#39;</code><code>);</code><br><code>$paginator</code> <code>=&nbsp;</code><code>$this</code><code>-&gt;get(</code><code>&#39;knp_paginator&#39;</code><code>);</code><code>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</code><br><code>$pagination</code> <code>=&nbsp;</code><code>$paginator</code><code>-&gt;paginate(</code><code>$qb</code><code>,&nbsp;</code><code>$page</code><code>,</code><code>$limit</code><code>);</code><code>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</code> <code>&nbsp; &nbsp; &nbsp;&nbsp;</code><br><code>return</code> <code>$this</code><code>-&gt;render(</code><code>&#39;&#39;</code><code>,[</code><code>&#39;pagination&#39;</code> <code>=&gt;&nbsp;</code><code>$pagination</code><code>]);</code>&nbsp;</blockquote><blockquote><code>{% for value in pagination %}</code><br><code>{{value.title}}{#直接就是值了#}</code><br><code>{% endfor %}</code><br><code>{{ knp_pagination_render(pagination) }}</code> </blockquote>', 1, 0, 1, 1),
(2, '上传文件', '上传文件', NULL, '2018-07-04 15:20:46', NULL, '<p>可以考虑<font><font>可以考虑使用</font></font><font><font><a href=\"https://github.com/dustin10/VichUploaderBundle\">VichUploaderBundle</a>组件</font></font></p><p>手动处理分两种 ，一个是控制器里直接处理，一个是注册服务，控制器引用处理</p><p>一、控制器处理</p><p>1、Entity里引入 use Symfony\\Component\\Validator\\Constraints as Assert;</p><p>2、定义字段 @Assert\\File(mimeTypes={\"image/png\",\"image/jpeg\"})</p><p>3、表单类Form 引入字段 -&gt;add(\"file\",FileType::class),编辑的时候可以加上参数[\'data_class\'=&gt;null,],否则会报错</p><p>4、新增提交后处理</p><blockquote><p>$file = $form-&gt;get(\'thumb\')-&gt;getData();</p><p>if($file !== null){</p><p style=\"margin-left: 40px;\">	$fileName = $this-&gt;generateUniqueFileName().\'.\'.$file-&gt;guessExtension();</p><p style=\"margin-left: 40px;\">	// moves the file to the directory where brochures are stored</p><p style=\"margin-left: 40px;\">	$file-&gt;move(</p><p style=\"margin-left: 80px;\">		$this-&gt;getParameter(\'upload_path\'),</p><p style=\"margin-left: 80px;\">		$fileName</p><p style=\"margin-left: 40px;\">	);</p><p style=\"margin-left: 40px;\">	$article-&gt;setThumb($fileName);</p><p style=\"margin-left: 40px;\">$article = $form-&gt;getData();</p><p style=\"margin-left: 40px;\">//入库</p><p>}</p></blockquote><p style=\"margin-left: 40px;\"><br></p><p><br></p><p>5、设置上传路径参数&nbsp; app\\config\\service.yaml</p><pre><code><span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">parameters</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n    <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">upload_path</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span> <span class=\"s\" style=\"box-sizing: border-box; color: rgb(86, 219, 58);\">\'%kernel.project_dir%/public/uploads\'</span></code></pre><p>6、保存到数据库即可</p><p>二、服务</p><p>1、定义服务类&nbsp;</p><pre><code class=\"lang-php\">// src/Service/FileUploader.php\r\nnamespace App\\Service;\r\n\r\nuse Symfony\\Component\\HttpFoundation\\File\\UploadedFile;\r\n\r\nclass FileUploader\r\n{\r\n&nbsp; &nbsp; private $targetDirectory;\r\n\r\n&nbsp; &nbsp; public function __construct($targetDirectory)\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; $this-&gt;targetDirectory = $targetDirectory;\r\n&nbsp; &nbsp; }\r\n\r\n&nbsp; &nbsp; public function upload(UploadedFile $file)\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; $fileName = md5(uniqid()).\'.\'.$file-&gt;guessExtension();\r\n\r\n&nbsp; &nbsp; &nbsp; &nbsp; $file-&gt;move($this-&gt;getTargetDirectory(), $fileName);\r\n\r\n&nbsp; &nbsp; &nbsp; &nbsp; return $fileName;\r\n&nbsp; &nbsp; }\r\n\r\n&nbsp; &nbsp; public function getTargetDirectory()\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; return $this-&gt;targetDirectory;\r\n&nbsp; &nbsp; }\r\n}<br></code></pre><p>2、注册服务</p><pre><code class=\"lang-php\"><span class=\"c1\" style=\"box-sizing: border-box; color: rgb(183, 41, 217); font-style: italic;\"># config/services.yaml</span>\r\n<span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">services</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n    <span class=\"c1\" style=\"box-sizing: border-box; color: rgb(183, 41, 217); font-style: italic;\"># ...</span>\r\n\r\n    <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">App\\Service\\FileUploader</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n        <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">arguments</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n            <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">$targetDirectory</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span> <span class=\"s\" style=\"box-sizing: border-box; color: rgb(86, 219, 58);\">\'%upload_path%\'\r\n\r\n</span></code></pre><p>3、控制器里使用&nbsp;</p><p>use App\\Service\\FileUploader</p><p>public function add(Request,$request,FileUploader $fileuploader)</p><p>{</p><p style=\"margin-left: 40px;\">//服务上传</p><p style=\"margin-left: 40px;\">$file = $form-&gt;get(\'thumb\')-&gt;getData();</p><p style=\"margin-left: 40px;\">if(null !== $file){</p><p style=\"margin-left: 80px;\">	$fileName = $fileUploader-&gt;upload($file);</p><p style=\"margin-left: 80px;\">	$article-&gt;setThumb($fileName);</p><p style=\"margin-left: 40px;\">}</p><p style=\"margin-left: 40px;\">$article = $form-&gt;getData();</p><p style=\"margin-left: 40px;\">//入库</p><p>}</p>', 1, 0, 1, 1),
(3, '超实用的Excel导出', '超实用的Excel导出', NULL, '2018-07-04 15:25:55', NULL, '<blockquote><p>public function get_20wan()<br>&nbsp;{<br>&nbsp;&nbsp;$users = M(\'user\')-&gt;order(\'id asc\')-&gt;select();<br>&nbsp;&nbsp;$str&nbsp; = \'&lt;html&gt;\';<br>&nbsp;&nbsp;$str .= \'&lt;head&gt;\';<br>&nbsp;&nbsp;$str .= \'&lt;meta http - equiv = \"Content-Type\" content = \"text/html; charset=utf-8\" &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;/head &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;body &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;table border = \"1\" align = \"center\" cellspacing = \"1\" cellpadding = \"1\" &gt; \';<br>&nbsp;&nbsp;<br>&nbsp;&nbsp;$str .= \'&lt;tr align = \"center\" &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;td nowrap &gt;&lt;b &gt; 手机号&lt;/b &gt;&lt;/td &gt; &lt;td nowrap &gt;&lt;b &gt; 业绩&lt;/b &gt;&lt;/td &gt;\';<br>&nbsp;&nbsp;$str .= \'&lt;/tr &gt; \';<br>&nbsp;&nbsp;foreach($users as $user){<br>&nbsp;&nbsp;&nbsp;//获取动态分红的小区业绩<br>&nbsp;&nbsp;&nbsp;$yj = $this-&gt;get_xiaji($user[\'id\']);<br>&nbsp;&nbsp;&nbsp;if(!$yj){ //没有业绩或只有一条线<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; continue;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp;if($yj &gt;=200000){&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;$str .= \'&lt;tr align = \"center\" &gt; \';&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;$str .= \"&lt;td style=\'vnd.ms-excel.numberformat:@\'&gt;\".$user[\'phone\'].\"&lt;/td &gt; &lt;td style=\'vnd.ms-excel.numberformat:@\'&gt;\".$yj.\"&lt;/td &gt; \";<br>&nbsp;&nbsp;&nbsp;&nbsp;$str .= \'&lt;/tr &gt; \';&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;}<br>&nbsp;&nbsp;$str .= \'&lt;/table &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;/body &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;/html &gt; \';</p><p style=\"margin-left: 0px;\">&nbsp;&nbsp;header(\"cache-control:no-cache,must-revalidate\");<br>&nbsp;&nbsp;header(\"Content-Type:application/vnd.ms-execl\");<br>&nbsp;&nbsp;header(\"Content-Type:application/octet-stream\");<br>&nbsp;&nbsp;header(\"Content-Type:application/force-download\");<br>&nbsp;&nbsp;header(\"Content-Disposition: attachment; filename=\".urlencode(\'业绩大于20w\').\'_\'.date(\'m-d\').\".xls\");<br>&nbsp;&nbsp;header(\'Expires:0\');<br>&nbsp;&nbsp;header(\'Pragma:public\');<br>&nbsp;&nbsp;echo \"\\xFF\\xFE\".mb_convert_encoding( $str, \'UCS-2LE\', \'UTF-8\' );<br>&nbsp;&nbsp;<br>&nbsp;}</p><p><br></p></blockquote>', 4, 0, 1, 1),
(4, 'redis的基本使用', 'redis的基本使用', NULL, '2018-07-05 16:59:27', NULL, '<p>一，字符串 string</p><p>set,get ,getset,mset,mget,incr,incrby,decr,decrby,exists,del,strlen,append</p><p>Redis超时:数据在限定时间内存活,你可以对key设置一个超时时间，当这个时间到达后会被删除。精度可以使用毫秒或秒。set key value ,expire key 5( set key value ex 10)，通过ttl key 返回剩余时间</p><p>二，散列 hash</p><p>hset(insert return 1 update return 0),hget,hmset,hmget,hgetall ,hexists ,hsetnx(不存在才执行)，hincrby,hdel,hkeys,hvals,hlen</p><p>三，列表 list</p><p>lpush,rpush,lpop,rpop,lrange,llen,lrem lrem key count value count = 0 删除所有值为value，count&lt;0 从右边删除count个值为value 返回删除的个数 count&gt;0从左边删除count个值为value返回删除的个数,lindex key index&nbsp; ,lset key index value,linsert key before|after&nbsp;value newvalue 往值为value的前面|后面插newvalue</p><p>四，集合 set</p><p>sadd,sismember,smembers,srem key value [value1...],sdiff key key1差集，sinter key key1 交集,sunion key key1 并集，sdiffstore,sinterstore,sunionstore,scard key 集合中的个数，srandmember key [count] 随机返回集中中count个值，spop key [count],随机弹出一个值</p><p>五，有序集合 sorted set</p><p>zadd key score value,zscore key value 获得key中值为value的score,zrange key start end [withscores] 从小到大获取某个范围的元素列表,zrevrange key start end [withscores]从大到小获取某个范围的元素列表，zrangebyscore key start end [withscores]获取分数在某个范围的元素列表，zincrby key score value增加key中值为value的分数+score,zcard key获取元素的个数,zcount key min max获得指定分数范围内的元素个数，zrem key member删除key中的member,zremrangebyrank key start end按照排名范围删除元素，zremrangebyscore key start end按照分数分为删除元素，zrank key member 获得元素排名（从小到大），zrevrank key member 获得元素排名（从大到小）</p><p>六，事务</p><p style=\"margin-left: 0px;\">multi&nbsp; command... exec,语法错误事务不执行，运行错误事务还是会提交 比如&nbsp; multi&nbsp; set a b lpush a c exec,lpush的a的类型不正确，但是第一条还是会执行；watch命令可以监控一个或多个建，一旦其中一个被修改或删除，之后的事务部会执行，监控一直持续到exec命令。比如 set a b ,watch a set a b1 multi set a b2 exec,此时因执行事务前a被修改成b1了，所以事务里的set a b2不被执行 get a 是b1</p>', 5, 0, 1, 1),
(5, '安装和设置Symfony框架', '安装和设置Symfony框架，要创建新的Symfony应用程序，首先要确保使用的是PHP 7.1或更高版本并安装了Composer。', NULL, '2018-07-05 21:14:13', NULL, '<p>安装和设置Symfony框架，要创建新的Symfony应用程序，首先要确保使用是PHP 7.1或更高版本并安装了Composer,安装好composer后可以设置中国镜像。<br></p><p>通过运行一下命令下载框架</p><blockquote><p><span style=\"color: rgb(65, 140, 175);\">composer create-project symfony/website-skeleton my-project</span><br></p></blockquote><p>要运行程序，可使用下面命令,访问 127.0.0.1:8000</p><blockquote><p><span style=\"color: rgb(65, 140, 175);\">php bin/console server:run</span><br></p></blockquote><p>或者配置web服务器</p><p>apache2.4配置如下，<font><font>在Apache 2.4中，</font></font><code class=\"notranslate\">Order Allow,Deny</code><font><font>已被替换</font></font><code class=\"notranslate\">Require all granted</code><font><font>。</font><font>因此，您需要修改</font></font><code class=\"notranslate\">Directory</code><font><font>权限设置，如下所示</font></font></p><pre><code class=\"lang-php\"><span class=\"nt\" style=\"box-sizing: border-box; color: rgb(204, 204, 204);\"></span>&lt;VirtualHost *:80&gt;\r\n&nbsp; &nbsp; ServerName domain.tld\r\n&nbsp; &nbsp; ServerAlias www.domain.tld\r\n\r\n&nbsp; &nbsp; DocumentRoot /var/www/project/public\r\n&nbsp; &nbsp; &lt;Directory /var/www/project/public&gt;\r\n&nbsp; &nbsp; &nbsp; &nbsp; #AllowOverride None\r\n&nbsp; &nbsp; &nbsp; &nbsp; #Order Allow,Deny\r\n&nbsp; &nbsp; &nbsp; &nbsp; #Allow from All\r\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Require all granted\r\n&nbsp; &nbsp; &nbsp; &nbsp; FallbackResource /index.php\r\n&nbsp; &nbsp; &lt;/Directory&gt;\r\n\r\n&nbsp; &nbsp; # uncomment the following lines if you install assets as symlinks\r\n&nbsp; &nbsp; # or run into problems when compiling LESS/Sass/CoffeeScript assets\r\n&nbsp; &nbsp; # &lt;Directory /var/www/project&gt;\r\n&nbsp; &nbsp; #&nbsp; &nbsp; &nbsp;Options FollowSymlinks\r\n&nbsp; &nbsp; # &lt;/Directory&gt;\r\n\r\n&nbsp; &nbsp; # optionally disable the fallback resource for the asset directories\r\n&nbsp; &nbsp; # which will allow Apache to return a 404 error when files are\r\n&nbsp; &nbsp; # not found instead of passing the request to Symfony\r\n&nbsp; &nbsp; &lt;Directory /var/www/project/public/bundles&gt;\r\n&nbsp; &nbsp; &nbsp; &nbsp; FallbackResource disabled\r\n&nbsp; &nbsp; &lt;/Directory&gt;\r\n&nbsp; &nbsp; ErrorLog /var/log/apache2/project_error.log\r\n&nbsp; &nbsp; CustomLog /var/log/apache2/project_access.log combined\r\n\r\n&nbsp; &nbsp; # optionally set the value of the environment variables used in the application\r\n&nbsp; &nbsp; #SetEnv APP_ENV prod\r\n&nbsp; &nbsp; #SetEnv APP_SECRET &lt;app-secret-id&gt;\r\n&nbsp; &nbsp; #SetEnv DATABASE_URL \"mysql://db_user:db_pass@host:3306/db_name\"\r\n&lt;/VirtualHost&gt;<span class=\"nt\" style=\"box-sizing: border-box; color: rgb(204, 204, 204);\"></span></code></pre><p>nginx配置如下：</p><blockquote><p>server {</p><p>&nbsp; &nbsp; server_name domain.tld <a href=\"http://www.domain.tld\" rel=\"nofollow\">www.domain.tld</a>;</p><p>&nbsp; &nbsp; root /var/www/project/public;</p><p>&nbsp; &nbsp; location / {</p><p>&nbsp; &nbsp; &nbsp; &nbsp; # try to serve file directly, fallback to index.php</p><p>&nbsp; &nbsp; &nbsp; &nbsp; try_files $uri /index.php$is_args$args;</p><p>&nbsp; &nbsp; }</p><p>&nbsp; &nbsp; location ~ ^/index\\.php(/|$) {</p><p>&nbsp; &nbsp; &nbsp; &nbsp; fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; fastcgi_split_path_info ^(.+\\.php)(/.*)$;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; include fastcgi_params;</p><p>&nbsp; &nbsp; &nbsp; &nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; fastcgi_param DOCUMENT_ROOT $realpath_root;</p><p>&nbsp; &nbsp; &nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; internal;</p><p>&nbsp; &nbsp; }</p><p>&nbsp; &nbsp; # return 404 for all other php files not matching the front controller</p><p>&nbsp; &nbsp; # this prevents access to other php files you don\'t want to be accessible.</p><p>&nbsp; &nbsp; location ~ \\.php$ {</p><p>&nbsp; &nbsp; &nbsp; &nbsp; return 404;</p><p>&nbsp; &nbsp; }</p><p>&nbsp; &nbsp; error_log /var/log/nginx/project_error.log;</p><p>&nbsp; &nbsp; access_log /var/log/nginx/project_access.log;</p><p>}</p></blockquote>', 1, 0, 1, 1),
(6, '在Symfony中创建您的第一页', '在Symfony中创建您的第一页,创建新页面 - 无论是HTML页面还是JSON端点 - 分为两步：创建一个控制器 创建路线', NULL, '2018-07-05 21:38:39', NULL, '<p>在Symfony中创建您的第一页,创建新页面 - 无论是HTML页面还是JSON端点 - 分为两步：创建一个控制器 创建路线<br></p><p>创建控制器</p><pre><code class=\"lang-php\">&lt;?php\r\n// src/Controller/LuckyController.php\r\nnamespace App\\Controller;\r\n\r\nuse Symfony\\Component\\HttpFoundation\\Response;\r\n\r\nclass LuckyController\r\n{\r\n&nbsp; &nbsp; public function number()\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; $number = random_int(0, 100);\r\n\r\n&nbsp; &nbsp; &nbsp; &nbsp; return new Response(\r\n&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \'&lt;html&gt;&lt;body&gt;Lucky number: \'.$number.\'&lt;/body&gt;&lt;/html&gt;\'\r\n&nbsp; &nbsp; &nbsp; &nbsp; );\r\n&nbsp; &nbsp; }\r\n}<br></code></pre><p>创建路由</p><pre><code># config/routes.yaml\r\n\r\n# the \"app_lucky_number\" route name is not important yet\r\napp_lucky_number:\r\n&nbsp; &nbsp; path: /lucky/number\r\n&nbsp; &nbsp; controller: App\\Controller\\LuckyController::number<br></code></pre><p>此时，访问 127.0.0.1:8000/lucky/number 访问即可</p><p>或通过使用annotation路由设置</p><pre><code>use Symfony\\Component\\Routing\\Annotation\\Route;\r\n\r\n...\r\n/**\r\n*@Route(\"/lucky/number\",name=\"app_lucky_number\")\r\n*/\r\npublic function number...</code></pre>', 1, 0, 1, 1),
(7, '路由', 'Symonfy中的路由', NULL, '2018-07-05 21:57:44', NULL, '<pre><code>namespace App\\Controller;\r\nuse Symfony\\Bundle\\FrameWorkBundle\\Controller\\Controller;\r\nuse Symfony\\Component\\Routing\\Annotation\\Route;\r\n\r\n&nbsp;&nbsp;/**\r\n&nbsp;&nbsp; * @Route(\"/site\")  //这是前缀定义\r\n &nbsp;&nbsp;*/\r\n&nbsp;&nbsp;class Blog\r\n&nbsp;&nbsp;{  ... }\r\n\r\n   /**\r\n&nbsp; &nbsp; &nbsp;* @Route(\"/blog/{page}\", name=\"blog_list\",methods={\"GET\",\"POST\"} requirements={\"page\"=\"\\d+\"} or requirements={\"page\":\"\\d+\"})\r\n&nbsp; &nbsp; &nbsp;*/\r\n   /**\r\n     * @Route(\"/blog/{page&lt;\\d+&gt;?1}\", name=\"blog_list\")\r\n     */\r\n&nbsp; &nbsp; public function list($page=1)\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; // ...\r\n&nbsp; &nbsp; }\r\n<br></code></pre><p>列出所有路由</p><pre><code>php bin/console debug:router</code></pre><p>控制器里生成url</p><pre><code>$url = $this-&gt;generateUrl(\r\n&nbsp;&nbsp;&nbsp;&nbsp;\'blog_list\',\r\n&nbsp;&nbsp;&nbsp;&nbsp;[\'page\'=&gt;12],\r\n);</code></pre><p>使用查询字符串，当你生成网址的时候多余的参数，将会以查询字符串的形式添加到url上</p><pre><code>$this-&gt;router-&gt;generate(\'blog\', array(\r\n&nbsp; &nbsp; \'page\' =&gt; 2,\r\n&nbsp; &nbsp; \'category\' =&gt; \'Symfony\',\r\n));\r\n// /blog/2?category=Symfony<br></code></pre><p>模板中使用url</p><pre><code>{{ path(\'blog_list\',{\'page\':2}) }}</code></pre>', 1, 0, 1, 1);

-- --------------------------------------------------------

--
-- 表的结构 `article_tag`
--

CREATE TABLE `article_tag` (
  `article_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 转存表中的数据 `article_tag`
--

INSERT INTO `article_tag` (`article_id`, `tag_id`) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(3, 4),
(4, 7),
(5, 1),
(5, 2),
(6, 1),
(6, 2),
(7, 1),
(7, 2);

-- --------------------------------------------------------

--
-- 表的结构 `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `level` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 转存表中的数据 `category`
--

INSERT INTO `category` (`id`, `pid`, `name`, `created_at`, `level`) VALUES
(1, 0, 'Symfony4', '2018-07-03 08:00:14', 1),
(2, 0, 'Thinkphp5', '2018-07-03 08:00:53', 1),
(3, 0, 'Flask', '2018-07-03 08:01:33', 1),
(4, 0, 'Thinkphp3', '2018-07-03 08:01:55', 1),
(5, 0, 'Redis', '2018-07-05 16:58:18', 1);

-- --------------------------------------------------------

--
-- 表的结构 `comment`
--

CREATE TABLE `comment` (
  `id` int(11) NOT NULL,
  `content` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_at` datetime NOT NULL,
  `article_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `migration_versions`
--

CREATE TABLE `migration_versions` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- 转存表中的数据 `migration_versions`
--

INSERT INTO `migration_versions` (`version`) VALUES
('20180702034242'),
('20180702034741'),
('20180702035945'),
('20180702044226'),
('20180702044625'),
('20180702050942'),
('20180702051247');

-- --------------------------------------------------------

--
-- 表的结构 `tag`
--

CREATE TABLE `tag` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 转存表中的数据 `tag`
--

INSERT INTO `tag` (`id`, `name`, `created_at`, `status`) VALUES
(1, 'PHP', '2018-07-03 08:06:41', 1),
(2, 'SYMFONY4', '2018-07-03 08:06:54', 1),
(3, 'THINKPHP5', '2018-07-03 08:07:03', 1),
(4, 'THINKPHP3', '2018-07-03 08:07:13', 1),
(5, 'PYTHON', '2018-07-03 08:07:26', 1),
(6, 'FLASK', '2018-07-03 08:07:33', 1),
(7, 'REDIS', '2018-07-05 16:58:27', 1);

-- --------------------------------------------------------

--
-- 表的结构 `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `article`
--
ALTER TABLE `article`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_23A0E6612469DE2` (`category_id`);

--
-- Indexes for table `article_tag`
--
ALTER TABLE `article_tag`
  ADD PRIMARY KEY (`article_id`,`tag_id`),
  ADD KEY `IDX_919694F97294869C` (`article_id`),
  ADD KEY `IDX_919694F9BAD26311` (`tag_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_9474526C7294869C` (`article_id`);

--
-- Indexes for table `migration_versions`
--
ALTER TABLE `migration_versions`
  ADD PRIMARY KEY (`version`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `article`
--
ALTER TABLE `article`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- 使用表AUTO_INCREMENT `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- 使用表AUTO_INCREMENT `comment`
--
ALTER TABLE `comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- 使用表AUTO_INCREMENT `tag`
--
ALTER TABLE `tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- 使用表AUTO_INCREMENT `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- 限制导出的表
--

--
-- 限制表 `article`
--
ALTER TABLE `article`
  ADD CONSTRAINT `FK_23A0E6612469DE2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`);

--
-- 限制表 `article_tag`
--
ALTER TABLE `article_tag`
  ADD CONSTRAINT `FK_919694F97294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_919694F9BAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE;

--
-- 限制表 `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `FK_9474526C7294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
