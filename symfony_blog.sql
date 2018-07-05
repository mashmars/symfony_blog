/*
Navicat MySQL Data Transfer

Source Server         : 本地
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : symfony_blog

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2018-07-05 17:02:59
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descript` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thumb` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `category_id` int(11) DEFAULT NULL,
  `views` int(11) DEFAULT NULL,
  `is_comment` tinyint(1) NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_23A0E6612469DE2` (`category_id`),
  CONSTRAINT `FK_23A0E6612469DE2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES ('1', 'symfony4如何使用分页功能', 'symfony中通过knp组件实现分页', null, '2018-07-04 14:00:53', null, '为了记录symfony4的学习过程，首先准备了后台的文章管理系统，通过一系列的准备工作，比如选择编辑器等；另外就是先解决文章的分页功能，在这儿通过使用knp分页组件完成；<blockquote>composer require &quot;knplabs/knp-paginator-bundle&quot; &nbsp;</blockquote><blockquote><code>$qb</code> <code>=&nbsp;</code><code>$em</code><code>-&gt;getRepository(</code><code>&#39;AppBundle:DemoList&#39;</code><code>)-&gt;createQueryBuilder(</code><code>&#39;u&#39;</code><code>);</code><br><code>$paginator</code> <code>=&nbsp;</code><code>$this</code><code>-&gt;get(</code><code>&#39;knp_paginator&#39;</code><code>);</code><code>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</code><br><code>$pagination</code> <code>=&nbsp;</code><code>$paginator</code><code>-&gt;paginate(</code><code>$qb</code><code>,&nbsp;</code><code>$page</code><code>,</code><code>$limit</code><code>);</code><code>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</code> <code>&nbsp; &nbsp; &nbsp;&nbsp;</code><br><code>return</code> <code>$this</code><code>-&gt;render(</code><code>&#39;&#39;</code><code>,[</code><code>&#39;pagination&#39;</code> <code>=&gt;&nbsp;</code><code>$pagination</code><code>]);</code>&nbsp;</blockquote><blockquote><code>{% for value in pagination %}</code><br><code>{{value.title}}{#直接就是值了#}</code><br><code>{% endfor %}</code><br><code>{{ knp_pagination_render(pagination) }}</code> </blockquote>', '1', '0', '1', '1');
INSERT INTO `article` VALUES ('2', '上传文件', '上传文件', null, '2018-07-04 15:20:46', null, '<p>可以考虑<font><font>可以考虑使用</font></font><font><font><a href=\"https://github.com/dustin10/VichUploaderBundle\">VichUploaderBundle</a>组件</font></font></p><p>手动处理分两种 ，一个是控制器里直接处理，一个是注册服务，控制器引用处理</p><p>一、控制器处理</p><p>1、Entity里引入 use Symfony\\Component\\Validator\\Constraints as Assert;</p><p>2、定义字段 @Assert\\File(mimeTypes={\"image/png\",\"image/jpeg\"})</p><p>3、表单类Form 引入字段 -&gt;add(\"file\",FileType::class),编辑的时候可以加上参数[\'data_class\'=&gt;null,],否则会报错</p><p>4、新增提交后处理</p><blockquote><p>$file = $form-&gt;get(\'thumb\')-&gt;getData();</p><p>if($file !== null){</p><p style=\"margin-left: 40px;\">	$fileName = $this-&gt;generateUniqueFileName().\'.\'.$file-&gt;guessExtension();</p><p style=\"margin-left: 40px;\">	// moves the file to the directory where brochures are stored</p><p style=\"margin-left: 40px;\">	$file-&gt;move(</p><p style=\"margin-left: 80px;\">		$this-&gt;getParameter(\'upload_path\'),</p><p style=\"margin-left: 80px;\">		$fileName</p><p style=\"margin-left: 40px;\">	);</p><p style=\"margin-left: 40px;\">	$article-&gt;setThumb($fileName);</p><p style=\"margin-left: 40px;\">$article = $form-&gt;getData();</p><p style=\"margin-left: 40px;\">//入库</p><p>}</p></blockquote><p style=\"margin-left: 40px;\"><br></p><p><br></p><p>5、设置上传路径参数&nbsp; app\\config\\service.yaml</p><pre><code><span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">parameters</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n    <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">upload_path</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span> <span class=\"s\" style=\"box-sizing: border-box; color: rgb(86, 219, 58);\">\'%kernel.project_dir%/public/uploads\'</span></code></pre><p>6、保存到数据库即可</p><p>二、服务</p><p>1、定义服务类&nbsp;</p><pre><code class=\"lang-php\">// src/Service/FileUploader.php\r\nnamespace App\\Service;\r\n\r\nuse Symfony\\Component\\HttpFoundation\\File\\UploadedFile;\r\n\r\nclass FileUploader\r\n{\r\n&nbsp; &nbsp; private $targetDirectory;\r\n\r\n&nbsp; &nbsp; public function __construct($targetDirectory)\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; $this-&gt;targetDirectory = $targetDirectory;\r\n&nbsp; &nbsp; }\r\n\r\n&nbsp; &nbsp; public function upload(UploadedFile $file)\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; $fileName = md5(uniqid()).\'.\'.$file-&gt;guessExtension();\r\n\r\n&nbsp; &nbsp; &nbsp; &nbsp; $file-&gt;move($this-&gt;getTargetDirectory(), $fileName);\r\n\r\n&nbsp; &nbsp; &nbsp; &nbsp; return $fileName;\r\n&nbsp; &nbsp; }\r\n\r\n&nbsp; &nbsp; public function getTargetDirectory()\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; return $this-&gt;targetDirectory;\r\n&nbsp; &nbsp; }\r\n}<br></code></pre><p>2、注册服务</p><pre><code class=\"lang-php\"><span class=\"c1\" style=\"box-sizing: border-box; color: rgb(183, 41, 217); font-style: italic;\"># config/services.yaml</span>\r\n<span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">services</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n    <span class=\"c1\" style=\"box-sizing: border-box; color: rgb(183, 41, 217); font-style: italic;\"># ...</span>\r\n\r\n    <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">App\\Service\\FileUploader</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n        <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">arguments</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n            <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">$targetDirectory</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span> <span class=\"s\" style=\"box-sizing: border-box; color: rgb(86, 219, 58);\">\'%upload_path%\'\r\n\r\n</span></code></pre><p>3、控制器里使用&nbsp;</p><p>use App\\Service\\FileUploader</p><p>public function add(Request,$request,FileUploader $fileuploader)</p><p>{</p><p style=\"margin-left: 40px;\">//服务上传</p><p style=\"margin-left: 40px;\">$file = $form-&gt;get(\'thumb\')-&gt;getData();</p><p style=\"margin-left: 40px;\">if(null !== $file){</p><p style=\"margin-left: 80px;\">	$fileName = $fileUploader-&gt;upload($file);</p><p style=\"margin-left: 80px;\">	$article-&gt;setThumb($fileName);</p><p style=\"margin-left: 40px;\">}</p><p style=\"margin-left: 40px;\">$article = $form-&gt;getData();</p><p style=\"margin-left: 40px;\">//入库</p><p>}</p>', '1', '0', '1', '1');
INSERT INTO `article` VALUES ('3', '超实用的Excel导出', '超实用的Excel导出', null, '2018-07-04 15:25:55', null, '<blockquote><p>public function get_20wan()<br>&nbsp;{<br>&nbsp;&nbsp;$users = M(\'user\')-&gt;order(\'id asc\')-&gt;select();<br>&nbsp;&nbsp;$str&nbsp; = \'&lt;html&gt;\';<br>&nbsp;&nbsp;$str .= \'&lt;head&gt;\';<br>&nbsp;&nbsp;$str .= \'&lt;meta http - equiv = \"Content-Type\" content = \"text/html; charset=utf-8\" &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;/head &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;body &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;table border = \"1\" align = \"center\" cellspacing = \"1\" cellpadding = \"1\" &gt; \';<br>&nbsp;&nbsp;<br>&nbsp;&nbsp;$str .= \'&lt;tr align = \"center\" &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;td nowrap &gt;&lt;b &gt; 手机号&lt;/b &gt;&lt;/td &gt; &lt;td nowrap &gt;&lt;b &gt; 业绩&lt;/b &gt;&lt;/td &gt;\';<br>&nbsp;&nbsp;$str .= \'&lt;/tr &gt; \';<br>&nbsp;&nbsp;foreach($users as $user){<br>&nbsp;&nbsp;&nbsp;//获取动态分红的小区业绩<br>&nbsp;&nbsp;&nbsp;$yj = $this-&gt;get_xiaji($user[\'id\']);<br>&nbsp;&nbsp;&nbsp;if(!$yj){ //没有业绩或只有一条线<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; continue;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp;if($yj &gt;=200000){&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;$str .= \'&lt;tr align = \"center\" &gt; \';&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;$str .= \"&lt;td style=\'vnd.ms-excel.numberformat:@\'&gt;\".$user[\'phone\'].\"&lt;/td &gt; &lt;td style=\'vnd.ms-excel.numberformat:@\'&gt;\".$yj.\"&lt;/td &gt; \";<br>&nbsp;&nbsp;&nbsp;&nbsp;$str .= \'&lt;/tr &gt; \';&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;}<br>&nbsp;&nbsp;$str .= \'&lt;/table &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;/body &gt; \';<br>&nbsp;&nbsp;$str .= \'&lt;/html &gt; \';</p><p style=\"margin-left: 0px;\">&nbsp;&nbsp;header(\"cache-control:no-cache,must-revalidate\");<br>&nbsp;&nbsp;header(\"Content-Type:application/vnd.ms-execl\");<br>&nbsp;&nbsp;header(\"Content-Type:application/octet-stream\");<br>&nbsp;&nbsp;header(\"Content-Type:application/force-download\");<br>&nbsp;&nbsp;header(\"Content-Disposition: attachment; filename=\".urlencode(\'业绩大于20w\').\'_\'.date(\'m-d\').\".xls\");<br>&nbsp;&nbsp;header(\'Expires:0\');<br>&nbsp;&nbsp;header(\'Pragma:public\');<br>&nbsp;&nbsp;echo \"\\xFF\\xFE\".mb_convert_encoding( $str, \'UCS-2LE\', \'UTF-8\' );<br>&nbsp;&nbsp;<br>&nbsp;}</p><p><br></p></blockquote>', '4', '0', '1', '1');
INSERT INTO `article` VALUES ('4', 'redis的基本使用', 'redis的基本使用', null, '2018-07-05 16:59:52', null, '<p>一，字符串 string</p><p>set,get ,getset,mset,mget,incr,incrby,decr,decrby,exists,del,strlen,append</p><p>Redis超时:数据在限定时间内存活,你可以对key设置一个超时时间，当这个时间到达后会被删除。精度可以使用毫秒或秒。set key value ,expire key 5( set key value ex 10)，通过ttl key 返回剩余时间</p><p>二，散列 hash</p><p>hset(insert return 1 update return 0),hget,hmset,hmget,hgetall ,hexists ,hsetnx(不存在才执行)，hincrby,hdel,hkeys,hvals,hlen</p><p>三，列表 list</p><p>lpush,rpush,lpop,rpop,lrange,llen,lrem lrem key count value count = 0 删除所有值为value，count&lt;0 从右边删除count个值为value 返回删除的个数 count&gt;0从左边删除count个值为value返回删除的个数,lindex key index&nbsp; ,lset key index value,linsert key before|after&nbsp;value newvalue 往值为value的前面|后面插newvalue</p><p>四，集合 set</p><p>sadd,sismember,smembers,srem key value [value1...],sdiff key key1差集，sinter key key1 交集,sunion key key1 并集，sdiffstore,sinterstore,sunionstore,scard key 集合中的个数，srandmember key [count] 随机返回集中中count个值，spop key [count],随机弹出一个值</p><p>五，有序集合 sorted set</p><p>zadd key score value,zscore key value 获得key中值为value的score,zrange key start end [withscores] 从小到大获取某个范围的元素列表,zrevrange key start end [withscores]从大到小获取某个范围的元素列表，zrangebyscore key start end [withscores]获取分数在某个范围的元素列表，zincrby key score value增加key中值为value的分数+score,zcard key获取元素的个数,zcount key min max获得指定分数范围内的元素个数，zrem key member删除key中的member,zremrangebyrank key start end按照排名范围删除元素，zremrangebyscore key start end按照分数分为删除元素，zrank key member 获得元素排名（从小到大），zrevrank key member 获得元素排名（从大到小）</p><p>六，事务</p><p style=\"margin-left: 0px;\">multi&nbsp; command... exec,语法错误事务不执行，运行错误事务还是会提交 比如&nbsp; multi&nbsp; set a b lpush a c exec,lpush的a的类型不正确，但是第一条还是会执行；watch命令可以监控一个或多个建，一旦其中一个被修改或删除，之后的事务部会执行，监控一直持续到exec命令。比如 set a b ,watch a set a b1 multi set a b2 exec,此时因执行事务前a被修改成b1了，所以事务里的set a b2不被执行 get a 是b1</p>', '5', '0', '1', '1');

-- ----------------------------
-- Table structure for article_tag
-- ----------------------------
DROP TABLE IF EXISTS `article_tag`;
CREATE TABLE `article_tag` (
  `article_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`article_id`,`tag_id`),
  KEY `IDX_919694F97294869C` (`article_id`),
  KEY `IDX_919694F9BAD26311` (`tag_id`),
  CONSTRAINT `FK_919694F97294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_919694F9BAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of article_tag
-- ----------------------------
INSERT INTO `article_tag` VALUES ('1', '1');
INSERT INTO `article_tag` VALUES ('1', '2');
INSERT INTO `article_tag` VALUES ('2', '1');
INSERT INTO `article_tag` VALUES ('2', '2');
INSERT INTO `article_tag` VALUES ('3', '1');
INSERT INTO `article_tag` VALUES ('3', '4');
INSERT INTO `article_tag` VALUES ('4', '7');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `level` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('1', '0', 'symfony4', '2018-07-03 08:00:14', '1');
INSERT INTO `category` VALUES ('2', '0', 'thinkphp5', '2018-07-03 08:00:53', '1');
INSERT INTO `category` VALUES ('3', '0', 'flask', '2018-07-03 08:01:33', '1');
INSERT INTO `category` VALUES ('4', '0', 'thinkphp3', '2018-07-03 08:01:55', '1');
INSERT INTO `category` VALUES ('5', '0', 'Redis', '2018-07-05 16:58:37', '1');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_at` datetime NOT NULL,
  `article_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_9474526C7294869C` (`article_id`),
  CONSTRAINT `FK_9474526C7294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of comment
-- ----------------------------

-- ----------------------------
-- Table structure for migration_versions
-- ----------------------------
DROP TABLE IF EXISTS `migration_versions`;
CREATE TABLE `migration_versions` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of migration_versions
-- ----------------------------
INSERT INTO `migration_versions` VALUES ('20180702034242');
INSERT INTO `migration_versions` VALUES ('20180702034741');
INSERT INTO `migration_versions` VALUES ('20180702035945');
INSERT INTO `migration_versions` VALUES ('20180702044226');
INSERT INTO `migration_versions` VALUES ('20180702044625');
INSERT INTO `migration_versions` VALUES ('20180702050942');
INSERT INTO `migration_versions` VALUES ('20180702051247');

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES ('1', 'PHP', '2018-07-03 08:06:41', '1');
INSERT INTO `tag` VALUES ('2', 'SYMFONY4', '2018-07-03 08:06:54', '1');
INSERT INTO `tag` VALUES ('3', 'THINKPHP5', '2018-07-03 08:07:03', '1');
INSERT INTO `tag` VALUES ('4', 'THINKPHP3', '2018-07-03 08:07:13', '1');
INSERT INTO `tag` VALUES ('5', 'PYTHON', '2018-07-03 08:07:26', '1');
INSERT INTO `tag` VALUES ('6', 'FLASK', '2018-07-03 08:07:33', '1');
INSERT INTO `tag` VALUES ('7', 'REDIS', '2018-07-05 16:58:48', '1');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
