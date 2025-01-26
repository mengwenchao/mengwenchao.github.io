---
layout: single
title: 【测试】CruiseControl笔记
date: 2010-10-25 14:29:38.000000000 +08:00
type: post
published: true
status: publish
categories:
- 未分类
tags:
- IT
meta:
  _edit_last: '1'
  views: '10800'
  _wp_old_slug: ''
  _jetpack_related_posts_cache: a:1:{s:32:"8f6677c9d6b0f903e98ad32ec61f8deb";a:2:{s:7:"expires";i:1484219495;s:7:"payload";a:0:{}}}
---
<div id="article">
<div>
<table id="content" border="0" cellspacing="10" cellpadding="0" width="650">
<tbody>
<tr>
<td>
<div>
<div>(1)<br />
背景：</div>
<div>测试是项目生命周期中很重要的一部分。若人工手动的对项目代码进行测试，则比较费时，特别是当项目比较大，升级比较频繁的情况下，人工手动测试显得效率非常低。本案例介绍CruiseControl实现对项目工程进行持续集成测试，从而使项目测试实现自动化，高效率。</div>
<div> </div>
<div>简介：<br />
CruiseControl(有时我们简称CC)是使用java语言编写的一个持续集成工具，是 一个持续测试（CI Continuous Integration）的服务器CI 服务器。<br />
在CC中，我们可以实现对项目的源码控制，编译，打包，发布及各种测试，如findBugs，pmd，checkStyle，junit，selenium等。而且CC提供了一个web界面使我们更加方便的查看构建项目的当前以及历史状态。<br />
虽然CruiseControl使用java语言编写，但他并不限制你只能构建JAVA项目，你可以通过ant等脚本构建各种语言的持续集成环境。</div>
<div> </div>
<div>(2)</div>
<div>CruiseControl安装：<br />
2.1 在CuriseControl安装之前，须确保已经安装了Java，SVN，Ant。<br />
安装java,ant,svn,且配置环境变量:<br />
1)<br />
JAVA配置环境变量<br />
须配置JAVA_HOME,及到path中添加%JAVA_HOME%bin;<br />
2)<br />
ANT配置环境变量:<br />
ANT_HOME,,及到path中添加%ANT_HOME%bin;<br />
<span style="color: #ff0000;">注意:<br />
必须指向CruiseControl中的ant目录.或系统用的ant的版本要大于等于CC自带ANT版本.<br />
若系统中以前已安装的ant版本低于CC自天带的ANT版本,则CC启动时会出错.<br />
若环境变量中的上面的"用户变量"中定义了path,则系统变量中的path会失效.</span><br />
3)<br />
安装SVN:<br />
在windows下,可以安装此版本:TortoiseSVN-1.6.2.16344-win32-svn-1.6.2.msi<br />
<span style="color: #ff0000;">安装命令行模式下可使用的SVN:Setup-Subversion-1.6.6.msi.</span><br />
注意：<br />
<span style="color: #ff0000;">1.安装的命令行版本，要跟windows大版本相同，如上面都是1.6版本的。否则会出错。</span><br />
2.须确保在命令行下,svn可以使用.因为CC启动后,会通过svn -update去配置库上更新CC中的项目代码.<br />
  可以用svn --version测试是否在命令行模式下可使用.</div>
<div>
2.2<br />
安装CruiseControl<br />
CruiseControl可以在Linux和Windows环境下安装，CruiseControl也是绿色软件，也可下载解压缩后就可以使用。<br />
在windows环境下载，安装CruiseControl.exe方式：<br />
1)<br />
首先安装你的CruiseControl(简称CC)，你可以选择exe的文件下载，直接安装就可以.<br />
2)<br />
启动:<br />
<strong>第一种方式:</strong><br />
在CC的安装根目录下,双击CruiseControl.bat来启动.或命令行模式到CC根目录,运行bat文件也可.当出现:<br />
wait for next time to build(第一个启动时) <br />
或<br />
BuildQueue    - BuildQueue started时表示CC已经启动成功。<br />
注意：<br />
可以在此CruiseControl.bat文件中，配置CC的最大内存，以及启动占用的各个端口。</div>
<div><strong>第二种方式:</strong><br />
安装完成后，我们打开<br />
“开始菜单”-&gt;“程序”-&gt; "CruiseControl" 就可以打开CruiseControl的服务。<br />
“开始菜单”-&gt;“程序”-&gt; “ReportingApp”是CruiseControl的浏览界面。<br />
3)<br />
查看<br />
打开浏览器在浏览器中输入:<br />
<a href="http://localhost:8080/dashboard">http://localhost:8080/dashboard</a>即可看到当前构建工程(build 项目)总的结果，包括构建成功与失败的工程数量。同时，可以对项目进行编译，build.<br />
<a href="http://localhost:8080/cruisecontrol/">http://localhost:8080/cruisecontrol/</a> 页面中显示了工程构建的列表，构建时间及现在的状态，并且可以对某工程强制重新构建。<span style="color: #ff0000;">单击工程名可以看到工程构建的详细信息，包括构建过程中的错误与警告，单元测试的结果以及各种代码检测工具(findBugs,pmd,checkStyle,javancss等)检测结果等</span>。</div>
<div>(3)<br />
<strong>CruiseControl目录及文件介绍：</strong><br />
apache-ant-1.7.0：CC自带的ant1.7.0.<br />
logs下面包括日志信息，可以通过在config.xml中指定日志路径和名称；<br />
projects：下面放的是需要进行持续集成的项目;<br />
lib目录中放有cruisecontrol.jar和其他运行需要的jar(如运行findBugs,PMD等插件的jar包)；<br />
artifacts目录：:输出目录，集成后生成的jar就保存在这里。(安装后不存在此目录，第一次运行后才会生成此目录)<br />
webapps：下是cruisecontrol build结果的网站,<br />
可以通过<a href="http://127.0.0.1:8080/cruisecontrol/">http://127.0.0.1:8080/cruisecontrol/</a>访问;<br />
可以通过<a href="http://127.0.0.1:8080/dashboard">http://127.0.0.1:8080/dashboard</a>来进行对你的项目进行编译发布到你指定的web容器上.</div>
<div>(4)<br />
<span style="color: #ff0000;">CruiseControl(以下简称 CC) 主要有两个配置文件：<br />
一个是config.xml，是CC初始化、调度等任务参数的配置；<br />
一个是build.xml，ant执行的配置文件，CC借助ant完成指定的任务，如clean,compile,war,junit,findbug,pmd,checkstyle等。</span></div>
<div>(4.1)</div>
<div><strong>CruiseControl配置文件config.xml分析</strong><br />
cruisecontrol的config文件，CC启动的时候会自动寻找此文件.</div>
<div>所有要集成到CC的项目,都要在config.xml中定义:只须在&lt;cruisecontrol&gt;中添加&lt;project&gt;及定义其子元素即可.<br />
config.xml分析:</div>
<div>
<div>
<div>&lt;cruisecontrol&gt;    <span style="color: #008000;">//cc的固有标签，cc中可以有多个project </span><br />
&lt;!--这个地方的项目名称要和你的projects目录下的项目名称一样--&gt;    <br />
<span style="color: #008000;">//监听器，会将当前项目的build状态，记录于status.txt中。 </span><br />
     &lt;listeners&gt; <br />
     &lt;/listeners&gt; <br />
<span style="color: #008000;">//&lt;bootstrappers&gt;用于从svn源码控制程序更新本地版本 </span><br />
      &lt;bootstrappers&gt; <br />
           <span style="color: #008000;">//svn </span><br />
           <span style="color: #008000;">//向ant提供当前信息 </span><br />
        &lt;/bootstrappers&gt; <br />
<span style="color: #008000;">//用于检查各个源码控制系统(项目源码)中是否发生变化，如果有，则在web页面显示变化过的文件名。&lt;modificationset&gt;的属性quietperiod（单位为秒）定义了一个时间值。如果CC检查到了变化，会自检查到变化的源码控制系统的最后一次check in 的时间开始等待，等待时间由quietperiod决定，等待结束之后才触发创建（build）过程，主要是防止有人在check in的过程当中就触发创建过程（可能check in只做了一半，这个时候触发创建显然是不正确的）.</span></div>
<div><span style="color: #008000;">check in：即是commit,即是将本地数据提交到配置库上;</span></div>
<div><span style="color: #008000;">check out即是将配置库上的数据更新到本地.</span> <br />
        &lt;modificationset quietperiod=<span style="color: #800000;">"30"</span>&gt; <br />
        &lt;/modificationset&gt; <br />
<span style="color: #008000;">//&lt;schedule &gt;定义build时间间隔为86400秒。若下面的ant标签中定义了time，则此处的时间将会失效。</span><br />
<span style="color: #008000;">//&lt;ant&gt;指定ant 的相关信息。buildfile定义build所需要的build.xml文件，time指定build目标的运行时间(这里定义为每天的23点59分执行) </span></div>
<div><span style="color: #ff0000;">说明: <br />
interval="86400": 即是3600秒*24小时=86400秒.说明每隔86400秒,CC便会自动执行当前项目的ant命令. <br />
time: 若在&lt;ant&gt;中添加time,则上面的interval将会失效.CC会根据time设置的时间来执行ANT命令. time="2359",表示每天的23点59分执行ANT. <br />
</span>        &lt;schedule interval=<span style="color: #800000;">"86400"</span>&gt; <br />
        &lt;/schedule&gt; <br />
<span style="color: #008000;">//log标签的dir属性指定日志目录。merge标签的dir属性指定需要被合并文件的路径，指定路径下的文件将会与日志文件合并，一般需要合并的文件是测试结果文件，这需要注意的地方是指定路径下的文件都要被合并到日志文件中，也就是说，为了不影响cc的日志文件的准确性，在生成每次的测试结果之前需要先把上次的测试结果删除。 </span><br />
         &lt;log&gt; <br />
         &lt;/log&gt; <br />
<span style="color: #008000;">// publishers的功能主要是发布build结果，我们主要用到的功能是artifactspublisher所定义的功能，也就是cc在build过程中产生的文件发布。在merge标签中我们已经知道，测试日志是cc在build过程中产生的文件，而且我们每次我们都要删除上次的测试结果，这里cc提供了一种机制让你保存测试结果，就是利用artifactspublisher标签。 </span></div>
<div>Dest定义目标目录，dir定义文件存储的起始目录。所有的文件会被cc从dir目录copy到dest目录。被copy到dest目录的文件会放在以当前时间命名的文件夹中。这里dir定义的是测试日志文件的所在目录。 <br />
          &lt;publishers&gt;    <span style="color: #008000;">//发布版本 </span><br />
                &lt;onsuccess&gt; <br />
                 &lt;/onsuccess&gt; <br />
           &lt;/publishers&gt; <br />
        &lt;/project&gt; <br />
也可以添加失败处理到发布中:如: <br />
     &lt;onfailure&gt;<span style="color: #008000;">//失败发送邮件到响应的人员 </span><br />
         &lt;always address=<span style="color: #800000;">"接收邮件方的邮箱"</span> /&gt; <br />
     &lt;/onfailure&gt;</span></div>
</div>
</div>
<div>(5)</div>
<div><strong>CruiseControl项目配置文件build.xml</strong><br />
搭建CruiseControl持续集成测试平台，最主要的工作是配置好config.xml及build.xml。. config.xml：为CruiseControl的配置文件，定义了CC的何时，如何进行项目测试。<br />
Build.xml：即是持续集成测试的项目工程中ant的配置文件。当CC执行项目测试时，将会利用ant来执行所有的逻辑处理。<br />
因此，项目要实现的各种测试，将须到build.xml中进行定义。<br />
5.1<br />
<span style="color: #ff0000;">clean操作，如果build之前不执行此操作，build检查到原有的class文件就不再编译。<br />
     &lt;delete file="${CLASS_DIR}/longcon-framework.jar" /&gt;<br />
     &lt;delete dir="target" quiet="true" /&gt;<br />
  &lt;delete dir="${CLASS_DIR}/source/classes" /&gt;<br />
 &lt;/target&gt;</div>
<div>(6)</div>
<div>CruiseControl集成各种测试工具:<br />
CruiseControl持续集成测试，常用的测试工具有：findBugs，PMD，checkStyle。<br />
集成时，只须在目标项目的build.xml配置文件中定义findBugs，PMD，checkStyle的实现过程。具体实现及findBugs，PMD，checkStyle相关知识，请参照我以下案例分析</div>
<div> </div>
<div>(7)<br />
<span style="color: #ff0000;">当cc正</span><span style="color: #ff0000;">在build时,</span>不能点击<a href="http://localhost:9999/cruisecontrol/">http://localhost:9999/cruisecontrol/</a>中正在build的项目,否则会后台出错,且影响本次编译的结果(有些类编译出错).</div>
<div> </div>
<div><strong><span style="color: #ff0000;">具体ant的用法，请参考另一个文章：《ant用法》</span></strong></div>
<div>
(8)<br />
每次build目标项目时,在控制台都可以看到SVN更新的信息,如:(D:delete,A:add,U:update)<br />
[cc]一月-29 16:15:07 VNBootstrapper- D    testlibcheckstyle.jar<br />
[cc]一月-29 16:15:10 VNBootstrapper- A    testlibcheckstyle-all-5.0.jar<br />
[cc]一月-29 16:15:10 VNBootstrapper- A    testlibsun_checks.xml<br />
[cc]一月-29 16:15:11 VNBootstrapper- A    testlibcheckstyle-5.0.jar<br />
[cc]一月-29 16:15:15 VNBootstrapper- A    testlibfindbugs.jar<br />
[cc]一月-29 16:15:15 VNBootstrapper- A    testlibcheckstyle-frames.xsl<br />
[cc]一月-29 16:15:22 VNBootstrapper- U    javacomcommonutilEncoderByMd5.java<br />
[cc]一月-29 16:15:22 VNBootstrapper- U    build.xml<br />
[cc]一月-29 16:15:24 VNBootstrapper- 更新到版本 244。</div>
<div>(9)</div>
<div>在<a href="http://localhost:9999/cruisecontrol/index">http://localhost:9999/cruisecontrol/index</a>中,通过Label项可以看到当前项目被build的次数.若build 次数过多,其log会占用硬盘过多空间.可以到CruiseControllogs中,删除对应的项目或进入对应项目,删除以前的log文件.</div>
<div>(10)</div>
<div>在CC的findBug页面:FindBugs was not run against this project. ---说明在CC运行到findbug时,findbug 运行不成功所致.</div>
<div>(11)</div>
<div>JSP页面显示不了报告.--&gt;可以了.config.xml文件中的&lt;log&gt;中没进行配置.</div>
</div>
</td>
</tr>
</tbody>
</table>
</div>
</div>
