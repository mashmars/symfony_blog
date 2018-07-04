/*
Navicat MySQL Data Transfer

Source Server         : 本地
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : symfony_blog

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2018-07-04 17:51:08
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES ('1', 'symfony4如何使用分页功能', 'symfony中通过knp组件实现分页', null, '2018-07-04 14:00:53', null, '为了记录symfony4的学习过程，首先准备了后台的文章管理系统，通过一系列的准备工作，比如选择编辑器等；另外就是先解决文章的分页功能，在这儿通过使用knp分页组件完成；<blockquote>composer require &quot;knplabs/knp-paginator-bundle&quot; &nbsp;</blockquote><blockquote><code>$qb</code> <code>=&nbsp;</code><code>$em</code><code>-&gt;getRepository(</code><code>&#39;AppBundle:DemoList&#39;</code><code>)-&gt;createQueryBuilder(</code><code>&#39;u&#39;</code><code>);</code><br><code>$paginator</code> <code>=&nbsp;</code><code>$this</code><code>-&gt;get(</code><code>&#39;knp_paginator&#39;</code><code>);</code><code>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</code><br><code>$pagination</code> <code>=&nbsp;</code><code>$paginator</code><code>-&gt;paginate(</code><code>$qb</code><code>,&nbsp;</code><code>$page</code><code>,</code><code>$limit</code><code>);</code><code>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</code> <code>&nbsp; &nbsp; &nbsp;&nbsp;</code><br><code>return</code> <code>$this</code><code>-&gt;render(</code><code>&#39;&#39;</code><code>,[</code><code>&#39;pagination&#39;</code> <code>=&gt;&nbsp;</code><code>$pagination</code><code>]);</code>&nbsp;</blockquote><blockquote><code>{% for value in pagination %}</code><br><code>{{value.title}}{#直接就是值了#}</code><br><code>{% endfor %}</code><br><code>{{ knp_pagination_render(pagination) }}</code> </blockquote>', '1', '0', '1', '1');
INSERT INTO `article` VALUES ('2', '上传文件', '上传文件', null, '2018-07-04 15:20:46', null, '<p>可以考虑<font><font>可以考虑使用</font></font><font><font><a href=\"https://github.com/dustin10/VichUploaderBundle\">VichUploaderBundle</a>组件</font></font></p><p>手动处理分两种 ，一个是控制器里直接处理，一个是注册服务，控制器引用处理</p><p>一、控制器处理</p><p>1、Entity里引入 use Symfony\\Component\\Validator\\Constraints as Assert;</p><p>2、定义字段 @Assert\\File(mimeTypes={\"image/png\",\"image/jpeg\"})</p><p>3、表单类Form 引入字段 -&gt;add(\"file\",FileType::class),编辑的时候可以加上参数[\'data_class\'=&gt;null,],否则会报错</p><p>4、新增提交后处理</p><blockquote><p>$file = $form-&gt;get(\'thumb\')-&gt;getData();</p><p>if($file !== null){</p><p style=\"margin-left: 40px;\">	$fileName = $this-&gt;generateUniqueFileName().\'.\'.$file-&gt;guessExtension();</p><p style=\"margin-left: 40px;\">	// moves the file to the directory where brochures are stored</p><p style=\"margin-left: 40px;\">	$file-&gt;move(</p><p style=\"margin-left: 80px;\">		$this-&gt;getParameter(\'upload_path\'),</p><p style=\"margin-left: 80px;\">		$fileName</p><p style=\"margin-left: 40px;\">	);</p><p style=\"margin-left: 40px;\">	$article-&gt;setThumb($fileName);</p><p style=\"margin-left: 40px;\">$article = $form-&gt;getData();</p><p style=\"margin-left: 40px;\">//入库</p><p>}</p></blockquote><p style=\"margin-left: 40px;\"><br></p><p><br></p><p>5、设置上传路径参数&nbsp; app\\config\\service.yaml</p><pre><code><span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">parameters</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n    <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">upload_path</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span> <span class=\"s\" style=\"box-sizing: border-box; color: rgb(86, 219, 58);\">\'%kernel.project_dir%/public/uploads\'</span></code></pre><p>6、保存到数据库即可</p><p>二、服务</p><p>1、定义服务类&nbsp;</p><pre><code class=\"lang-php\">// src/Service/FileUploader.php\r\nnamespace App\\Service;\r\n\r\nuse Symfony\\Component\\HttpFoundation\\File\\UploadedFile;\r\n\r\nclass FileUploader\r\n{\r\n&nbsp; &nbsp; private $targetDirectory;\r\n\r\n&nbsp; &nbsp; public function __construct($targetDirectory)\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; $this-&gt;targetDirectory = $targetDirectory;\r\n&nbsp; &nbsp; }\r\n\r\n&nbsp; &nbsp; public function upload(UploadedFile $file)\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; $fileName = md5(uniqid()).\'.\'.$file-&gt;guessExtension();\r\n\r\n&nbsp; &nbsp; &nbsp; &nbsp; $file-&gt;move($this-&gt;getTargetDirectory(), $fileName);\r\n\r\n&nbsp; &nbsp; &nbsp; &nbsp; return $fileName;\r\n&nbsp; &nbsp; }\r\n\r\n&nbsp; &nbsp; public function getTargetDirectory()\r\n&nbsp; &nbsp; {\r\n&nbsp; &nbsp; &nbsp; &nbsp; return $this-&gt;targetDirectory;\r\n&nbsp; &nbsp; }\r\n}<br></code></pre><p>2、注册服务</p><pre><code class=\"lang-php\"><span class=\"c1\" style=\"box-sizing: border-box; color: rgb(183, 41, 217); font-style: italic;\"># config/services.yaml</span>\r\n<span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">services</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n    <span class=\"c1\" style=\"box-sizing: border-box; color: rgb(183, 41, 217); font-style: italic;\"># ...</span>\r\n\r\n    <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">App\\Service\\FileUploader</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n        <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">arguments</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span>\r\n            <span class=\"l-Scalar-Plain\" style=\"box-sizing: border-box;\">$targetDirectory</span><span class=\"p-Indicator\" style=\"box-sizing: border-box; color: rgb(255, 132, 0);\">:</span> <span class=\"s\" style=\"box-sizing: border-box; color: rgb(86, 219, 58);\">\'%upload_path%\'\r\n\r\n</span></code></pre><p>3、控制器里使用&nbsp;</p><p>use App\\Service\\FileUploader</p><p>public function add(Request,$request,FileUploader $fileuploader)</p><p>{</p><p style=\"margin-left: 40px;\">//服务上传</p><p style=\"margin-left: 40px;\">$file = $form-&gt;get(\'thumb\')-&gt;getData();</p><p style=\"margin-left: 40px;\">if(null !== $file){</p><p style=\"margin-left: 80px;\">	$fileName = $fileUploader-&gt;upload($file);</p><p style=\"margin-left: 80px;\">	$article-&gt;setThumb($fileName);</p><p style=\"margin-left: 40px;\">}</p><p style=\"margin-left: 40px;\">$article = $form-&gt;getData();</p><p style=\"margin-left: 40px;\">//入库</p><p>}</p>', '1', '0', '1', '1');
INSERT INTO `article` VALUES ('3', '123', 'sf', '222961c43fc85a052c35d4cfce6dd29d.png', '2018-07-04 15:25:55', null, null, '1', '0', '1', '1');

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
INSERT INTO `article_tag` VALUES ('3', '2');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('1', '0', 'Symfony4', '2018-07-03 08:00:14', '1');
INSERT INTO `category` VALUES ('2', '0', 'Thinkphp5', '2018-07-03 08:00:53', '1');
INSERT INTO `category` VALUES ('3', '0', 'Flask', '2018-07-03 08:01:33', '1');
INSERT INTO `category` VALUES ('4', '0', 'Thinkphp3', '2018-07-03 08:01:55', '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES ('1', 'PHP', '2018-07-03 08:06:41', '1');
INSERT INTO `tag` VALUES ('2', 'SYMFONY4', '2018-07-03 08:06:54', '1');
INSERT INTO `tag` VALUES ('3', 'THINKPHP5', '2018-07-03 08:07:03', '1');
INSERT INTO `tag` VALUES ('4', 'THINKPHP3', '2018-07-03 08:07:13', '1');
INSERT INTO `tag` VALUES ('5', 'PYTHON', '2018-07-03 08:07:26', '1');
INSERT INTO `tag` VALUES ('6', 'FLASK', '2018-07-03 08:07:33', '1');

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
