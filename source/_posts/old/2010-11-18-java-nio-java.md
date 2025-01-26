---
layout: single
title: java nio 类介绍
date: 2010-11-18 15:05:59.000000000 +08:00
type: post
published: true
status: publish
categories:
- 未分类
tags:
- IT
meta:
  views: '467'
  _jetpack_related_posts_cache: a:1:{s:32:"8f6677c9d6b0f903e98ad32ec61f8deb";a:2:{s:7:"expires";i:1482922472;s:7:"payload";a:0:{}}}
---
<p><i>在JDK 1.4</i><i>以前，Java</i><i>的IO</i><i>操作集中在java.io</i><i>这个包中，是基于流的同步（blocking</i><i>）API</i><i>。对于大多数应用来说，这样的API</i><i>使用很方便，然而，一些对性能要求较高的应用，尤其是服务端应用，往往需要一个更为有效的方式来处理IO</i><i>。从JDK 1.4</i><i>起，NIO API</i><i>作为一个基于缓冲区，并能提供异步(non-blocking)IO</i><i>操作的API</i><i>被引入。本文对其进行深入的介绍。</i></p>
<p>NIO API主要集中在java.nio和它的subpackages中：</p>
<p>java.nio</p>
<p>定义了Buffer及其数据类型相关的子类。其中被java.nio.channels中的类用来进行IO操作的ByteBuffer的作用非常重要。</p>
<p>java.nio.channels</p>
<p>定义了一系列处理IO的Channel接口以及这些接口在文件系统和网络通讯上的实现。通过Selector这个类，还提供了进行异步IO操作的办法。这个包可以说是NIO API的核心。</p>
<p>java.nio.channels.spi</p>
<p>定义了可用来实现channel和selector API的抽象类。</p>
<p>java.nio.charset</p>
<p>定义了处理字符编码和解码的类。</p>
<p>java.nio.charset.spi</p>
<p>定义了可用来实现charset API的抽象类。</p>
<p>java.nio.channels.spi和java.nio.charset.spi这两个包主要被用来对现有NIO API进行扩展，在实际的使用中，我们一般只和另外的3个包打交道。下面将对这3个包一一介绍。</p>
<p>Package java.nio</p>
<p>这个包主要定义了Buffer及其子类。Buffer定义了一个线性存放primitive type数据的容器接口。对于除boolean以外的其他primitive type，都有一个相应的Buffer子类，ByteBuffer是其中最重要的一个子类。</p>
<p>下面这张UML类图描述了java.nio中的类的关系：</p>
<p><img border="0" hspace="0" alt="" align="baseline" src="{{ site.baseurl }}/img/o_buffer.gif" /></p>
<p><b>Buffer</b></p>
<p>定义了一个可以线性存放primitive type数据的容器接口。Buffer主要包含了与类型（byte, char…）无关的功能。值得注意的是Buffer及其子类都不是线程安全的。</p>
<p>每个Buffer都有以下的属性：</p>
<p>capacity</p>
<p>这个Buffer最多能放多少数据。capacity一般在buffer被创建的时候指定。</p>
<p>limit</p>
<p>在Buffer上进行的读写操作都不能越过这个下标。当写数据到buffer中时，limit一般和capacity相等，当读数据时，limit代表buffer中有效数据的长度。</p>
<p>position</p>
<p>读/写操作的当前下标。当使用buffer的相对位置进行读/写操作时，读/写会从这个下标进行，并在操作完成后，buffer会更新下标的值。</p>
<p>mark</p>
<p>一个临时存放的位置下标。调用mark()会将mark设为当前的position的值，以后调用reset()会将position属性设置为mark的值。mark的值总是小于等于position的值，如果将position的值设的比mark小，当前的mark值会被抛弃掉。</p>
<p>这些属性总是满足以下条件：</p>
<p>0 &lt;= mark &lt;= position &lt;= limit &lt;= capacity</p>
<p>limit和position的值除了通过limit()和position()函数来设置，也可以通过下面这些函数来改变：</p>
<p>Buffer clear()</p>
<p>把position设为0，把limit设为capacity，一般在把数据写入Buffer前调用。</p>
<p>Buffer flip()</p>
<p>把limit设为当前position，把position设为0，一般在从Buffer读出数据前调用。</p>
<p>Buffer rewind()</p>
<p>把position设为0，limit不变，一般在把数据重写入Buffer前调用。</p>
<p>Buffer对象有可能是只读的，这时，任何对该对象的写操作都会触发一个ReadOnlyBufferException。isReadOnly()方法可以用来判断一个Buffer是否只读。</p>
<p><b>ByteBuffer</b></p>
<p>在Buffer的子类中，ByteBuffer是一个地位较为特殊的类，因为在java.io.channels中定义的各种channel的IO操作基本上都是围绕ByteBuffer展开的。</p>
<p>ByteBuffer定义了4个static方法来做创建工作：</p>
<p>ByteBuffer allocate(int capacity)</p>
<p>创建一个指定capacity的ByteBuffer。</p>
<p>ByteBuffer allocateDirect(int capacity)</p>
<p>创建一个direct的ByteBuffer，这样的ByteBuffer在参与IO操作时性能会更好（很有可能是在底层的实现使用了DMA技术），相应的，创建和回收direct的ByteBuffer的代价也会高一些。isDirect()方法可以检查一个buffer是否是direct的。</p>
<p>ByteBuffer wrap(byte [] array)</p>
<p>ByteBuffer wrap(byte [] array, int offset, int length)</p>
<p>把一个byte数组或byte数组的一部分包装成ByteBuffer。</p>
<p>ByteBuffer定义了一系列get和put操作来从中读写byte数据，如下面几个：</p>
<p>byte get()</p>
<p>ByteBuffer get(byte [] dst)</p>
<p>byte get(int index)</p>
<p>ByteBuffer put(byte b)</p>
<p>ByteBuffer put(byte [] src)</p>
<p>ByteBuffer put(int index, byte b)</p>
<p>这些操作可分为绝对定位和相对定为两种，相对定位的读写操作依靠position来定位Buffer中的位置，并在操作完成后会更新position的值。</p>
<p>在其它类型的buffer中，也定义了相同的函数来读写数据，唯一不同的就是一些参数和返回值的类型。</p>
<p>除了读写byte类型数据的函数，ByteBuffer的一个特别之处是它还定义了读写其它primitive数据的方法，如：</p>
<p>int getInt()</p>
<p>从ByteBuffer中读出一个int值。</p>
<p>ByteBuffer putInt(int value)</p>
<p>写入一个int值到ByteBuffer中。</p>
<p>读写其它类型的数据牵涉到字节序问题，ByteBuffer会按其字节序（大字节序或小字节序）写入或读出一个其它类型的数据（int,long…）。字节序可以用order方法来取得和设置：</p>
<p>ByteOrder order()</p>
<p>返回ByteBuffer的字节序。</p>
<p>ByteBuffer order(ByteOrder bo)</p>
<p>设置ByteBuffer的字节序。</p>
<p>ByteBuffer另一个特别的地方是可以在它的基础上得到其它类型的buffer。如：</p>
<p>CharBuffer asCharBuffer()</p>
<p>为当前的ByteBuffer创建一个CharBuffer的视图。在该视图buffer中的读写操作会按照ByteBuffer的字节序作用到ByteBuffer中的数据上。</p>
<p>用这类方法创建出来的buffer会从ByteBuffer的position位置开始到limit位置结束，可以看作是这段数据的视图。视图buffer的readOnly属性和direct属性与ByteBuffer的一致，而且也只有通过这种方法，才可以得到其他数据类型的direct buffer。</p>
<p><b>ByteOrder</b></p>
<p>用来表示ByteBuffer字节序的类，可将其看成java中的enum类型。主要定义了下面几个static方法和属性：</p>
<p>ByteOrder BIG_ENDIAN</p>
<p>代表大字节序的ByteOrder。</p>
<p>ByteOrder LITTLE_ENDIAN</p>
<p>代表小字节序的ByteOrder。</p>
<p>ByteOrder nativeOrder()</p>
<p>返回当前硬件平台的字节序。</p>
<p><b>MappedByteBuffer</b></p>
<p>ByteBuffer的子类，是文件内容在内存中的映射。这个类的实例需要通过FileChannel的map()方法来创建。</p>
<p>接下来看看一个使用ByteBuffer的例子，这个例子从标准输入不停地读入字符，当读满一行后，将收集的字符写到标准输出：</p>
<p><b>public</b> <b>static</b> <b>void</b> main(String [] args)</p>
<p><b>throws</b> IOException</p>
<p>{</p>
<p>// 创建一个capacity为256的ByteBuffer</p>
<p>ByteBuffer buf = ByteBuffer.allocate(256);</p>
<p><b>while</b> (<b>true</b>) {</p>
<p>// 从标准输入流读入一个字符</p>
<p><b>int</b> c = System.in.read();</p>
<p>// 当读到输入流结束时，退出循环</p>
<p><b>if</b> (c == -1)</p>
<p><b>break</b>;</p>
<p>// 把读入的字符写入ByteBuffer中</p>
<p>buf.put((<b>byte</b>) c);</p>
<p>// 当读完一行时，输出收集的字符</p>
<p><b>if</b> (c == 'n') {</p>
<p>// 调用flip()使limit变为当前的position的值,position变为0,</p>
<p>// 为接下来从ByteBuffer读取做准备</p>
<p>buf.flip();</p>
<p>// 构建一个byte数组</p>
<p><b>byte</b> [] content = <b>new</b> <b>byte</b>[buf.limit()];</p>
<p>// 从ByteBuffer中读取数据到byte数组中</p>
<p>buf.get(content);</p>
<p>// 把byte数组的内容写到标准输出</p>
<p>System.out.print(<b>new</b> String(content));</p>
<p>// 调用clear()使position变为0,limit变为capacity的值，</p>
<p>// 为接下来写入数据到ByteBuffer中做准备</p>
<p>buf.clear();</p>
<p>}</p>
<p>}</p>
<p>}</p>
<p>Package java.nio.channels</p>
<p>这个包定义了Channel的概念，Channel表现了一个可以进行IO操作的通道（比如，通过FileChannel，我们可以对文件进行读写操作）。java.nio.channels包含了文件系统和网络通讯相关的channel类。这个包通过Selector和SelectableChannel这两个类，还定义了一个进行异步（non-blocking）IO操作的API，这对需要高性能IO的应用非常重要。</p>
<p>下面这张UML类图描述了java.nio.channels中interface的关系：</p>
<p><img border="0" hspace="0" alt="" align="baseline" src="{{ site.baseurl }}/img/o_channel.gif" /></p>
<p><strong>Channel</strong></p>
<p>Channel表现了一个可以进行IO操作的通道，该interface定义了以下方法：</p>
<p>boolean isOpen()</p>
<p>该Channel是否是打开的。</p>
<p>void close()</p>
<p>关闭这个Channel，相关的资源会被释放。</p>
<p><b>ReadableByteChannel</b></p>
<p>定义了一个可从中读取byte数据的channel interface。</p>
<p>int read(ByteBuffer dst)</p>
<p>从channel中读取byte数据并写到ByteBuffer中。返回读取的byte数。</p>
<p><b>WritableByteChannel</b></p>
<p>定义了一个可向其写byte数据的channel interface。</p>
<p>int write(ByteBuffer src)</p>
<p>从ByteBuffer中读取byte数据并写到channel中。返回写出的byte数。</p>
<p><b>ByteChannel</b></p>
<p>ByteChannel并没有定义新的方法，它的作用只是把ReadableByteChannel和WritableByteChannel合并在一起。</p>
<p><b>ScatteringByteChannel</b></p>
<p>继承了ReadableByteChannel并提供了同时往几个ByteBuffer中写数据的能力。</p>
<p><b>GatheringByteChannel</b></p>
<p>继承了WritableByteChannel并提供了同时从几个ByteBuffer中读数据的能力。</p>
<p><b>InterruptibleChannel</b></p>
<p>用来表现一个可以被异步关闭的Channel。这表现在两方面：</p>
<p>1． 当一个InterruptibleChannel的close()方法被调用时，其它block在这个InterruptibleChannel的IO操作上的线程会接收到一个AsynchronousCloseException。</p>
<p>2． 当一个线程block在InterruptibleChannel的IO操作上时，另一个线程调用该线程的interrupt()方法会导致channel被关闭，该线程收到一个ClosedByInterruptException，同时线程的interrupt状态会被设置。</p>
<p>接下来的这张UML类图描述了java.nio.channels中类的关系：</p>
<p><img border="0" hspace="0" alt="" align="baseline" src="{{ site.baseurl }}/img/o_channel-class.gif" /></p>
<p><b>异步IO</b></p>
<p>异步IO的支持可以算是NIO API中最重要的功能，异步IO允许应用程序同时监控多个channel以提高性能，这一功能是通过Selector，SelectableChannel和SelectionKey这3个类来实现的。</p>
<p>SelectableChannel代表了可以支持异步IO操作的channel，可以将其注册在Selector上，这种注册的关系由SelectionKey这个类来表现（见UML图）。Selector这个类通过select()函数，给应用程序提供了一个可以同时监控多个IO channel的方法：</p>
<p>应用程序通过调用select()函数，让Selector监控注册在其上的多个SelectableChannel，当有channel的IO操作可以进行时，select()方法就会返回以让应用程序检查channel的状态，并作相应的处理。</p>
<p>下面是JDK 1.4中异步IO的一个例子，这段code使用了异步IO实现了一个time server：</p>
<p><b>private</b> <b>static</b> <b>void</b> acceptConnections(<b>int</b> port) <b>throws</b> Exception {</p>
<p>// 打开一个Selector</p>
<p>Selector acceptSelector =</p>
<p>SelectorProvider.provider().openSelector();</p>
<p>// 创建一个ServerSocketChannel，这是一个SelectableChannel的子类</p>
<p>ServerSocketChannel ssc = ServerSocketChannel.open();</p>
<p>// 将其设为non-blocking状态，这样才能进行异步IO操作</p>
<p>ssc.configureBlocking(<b>false</b>);</p>
<p>// 给ServerSocketChannel对应的socket绑定IP和端口</p>
<p>InetAddress lh = InetAddress.getLocalHost();</p>
<p>InetSocketAddress isa = <b>new</b> InetSocketAddress(lh, port);</p>
<p>ssc.socket().bind(isa);</p>
<p>// 将ServerSocketChannel注册到Selector上，返回对应的SelectionKey</p>
<p>SelectionKey acceptKey =</p>
<p>ssc.register(acceptSelector, SelectionKey.OP_ACCEPT);</p>
<p><b>int</b> keysAdded = 0;</p>
<p>// 用select()函数来监控注册在Selector上的SelectableChannel</p>
<p>// 返回值代表了有多少channel可以进行IO操作 (ready for IO)</p>
<p><b>while</b> ((keysAdded = acceptSelector.select()) &gt; 0) {</p>
<p>// selectedKeys()返回一个SelectionKey的集合，</p>
<p>// 其中每个SelectionKey代表了一个可以进行IO操作的channel。</p>
<p>// 一个ServerSocketChannel可以进行IO操作意味着有新的TCP连接连入了</p>
<p>Set readyKeys = acceptSelector.selectedKeys();</p>
<p>Iterator i = readyKeys.iterator();</p>
<p><b>while</b> (i.hasNext()) {</p>
<p>SelectionKey sk = (SelectionKey) i.next();</p>
<p>// 需要将处理过的key从selectedKeys这个集合中删除</p>
<p>i.remove();</p>
<p>// 从SelectionKey得到对应的channel</p>
<p>ServerSocketChannel nextReady =</p>
<p>(ServerSocketChannel) sk.channel();</p>
<p>// 接受新的TCP连接</p>
<p>Socket s = nextReady.accept().socket();</p>
<p>// 把当前的时间写到这个新的TCP连接中</p>
<p>PrintWriter out =</p>
<p><b>new</b> PrintWriter(s.getOutputStream(), <b>true</b>);</p>
<p>Date now = <b>new</b> Date();</p>
<p>out.println(now);</p>
<p>// 关闭连接</p>
<p>out.close();</p>
<p>}</p>
<p>}</p>
<p>}</p>
<p>这是个纯粹用于演示的例子，因为只有一个ServerSocketChannel需要监控，所以其实并不真的需要使用到异步IO。不过正因为它的简单，可以很容易地看清楚异步IO是如何工作的。</p>
<p><b>SelectableChannel</b></p>
<p>这个抽象类是所有支持异步IO操作的channel（如DatagramChannel、SocketChannel）的父类。SelectableChannel可以注册到一个或多个Selector上以进行异步IO操作。</p>
<p>SelectableChannel可以是blocking和non-blocking模式（所有channel创建的时候都是blocking模式），只有non-blocking的SelectableChannel才可以参与异步IO操作。</p>
<p>SelectableChannel configureBlocking(boolean block)</p>
<p>设置blocking模式。</p>
<p>boolean isBlocking()</p>
<p>返回blocking模式。</p>
<p>通过register()方法，SelectableChannel可以注册到Selector上。</p>
<p>int validOps()</p>
<p>返回一个bit mask，表示这个channel上支持的IO操作。当前在SelectionKey中，用静态常量定义了4种IO操作的bit值：OP_ACCEPT，OP_CONNECT，OP_READ和OP_WRITE。</p>
<p>SelectionKey register(Selector sel, int ops)</p>
<p>将当前channel注册到一个Selector上并返回对应的SelectionKey。在这以后，通过调用Selector的select()函数就可以监控这个channel。ops这个参数是一个bit mask，代表了需要监控的IO操作。</p>
<p>SelectionKey register(Selector sel, int ops, Object att)</p>
<p>这个函数和上一个的意义一样，多出来的att参数会作为attachment被存放在返回的SelectionKey中，这在需要存放一些session state的时候非常有用。</p>
<p>boolean isRegistered()</p>
<p>该channel是否已注册在一个或多个Selector上。</p>
<p>SelectableChannel还提供了得到对应SelectionKey的方法：</p>
<p>SelectionKey keyFor(Selector sel)</p>
<p>返回该channe在Selector上的注册关系所对应的SelectionKey。若无注册关系，返回null。</p>
<p><b>Selector</b></p>
<p>Selector可以同时监控多个SelectableChannel的IO状况，是异步IO的核心。</p>
<p>Selector open()</p>
<p>Selector的一个静态方法，用于创建实例。</p>
<p>在一个Selector中，有3个SelectionKey的集合：</p>
<p>1． key set代表了所有注册在这个Selector上的channel，这个集合可以通过keys()方法拿到。</p>
<p>2． Selected-key set代表了所有通过select()方法监测到可以进行IO操作的channel，这个集合可以通过selectedKeys()拿到。</p>
<p>3． Cancelled-key set代表了已经cancel了注册关系的channel，在下一个select()操作中，这些channel对应的SelectionKey会从key set和cancelled-key set中移走。这个集合无法直接访问。</p>
<p>以下是select()相关方法的说明：</p>
<p>int select()</p>
<p>监控所有注册的channel，当其中有注册的IO操作可以进行时，该函数返回，并将对应的SelectionKey加入selected-key set。</p>
<p>int select(long timeout)</p>
<p>可以设置超时的select()操作。</p>
<p>int selectNow()</p>
<p>进行一个立即返回的select()操作。</p>
<p>Selector wakeup()</p>
<p>使一个还未返回的select()操作立刻返回。</p>
<p><b>SelectionKey</b></p>
<p>代表了Selector和SelectableChannel的注册关系。</p>
<p>Selector定义了4个静态常量来表示4种IO操作，这些常量可以进行位操作组合成一个bit mask。</p>
<p>int OP_ACCEPT</p>
<p>有新的网络连接可以accept，ServerSocketChannel支持这一异步IO。</p>
<p>int OP_CONNECT</p>
<p>代表连接已经建立（或出错），SocketChannel支持这一异步IO。</p>
<p>int OP_READ</p>
<p>int OP_WRITE</p>
<p>代表了读、写操作。</p>
<p>以下是其主要方法：</p>
<p>Object attachment()</p>
<p>返回SelectionKey的attachment，attachment可以在注册channel的时候指定。</p>
<p>Object attach(Object ob)</p>
<p>设置SelectionKey的attachment。</p>
<p>SelectableChannel channel()</p>
<p>返回该SelectionKey对应的channel。</p>
<p>Selector selector()</p>
<p>返回该SelectionKey对应的Selector。</p>
<p>void cancel()</p>
<p>cancel这个SelectionKey所对应的注册关系。</p>
<p>int interestOps()</p>
<p>返回代表需要Selector监控的IO操作的bit mask。</p>
<p>SelectionKey interestOps(int ops)</p>
<p>设置interestOps。</p>
<p>int readyOps()</p>
<p>返回一个bit mask，代表在相应channel上可以进行的IO操作。</p>
<p><b>ServerSocketChannel</b></p>
<p>支持异步操作，对应于java.net.ServerSocket这个类，提供了TCP协议IO接口，支持OP_ACCEPT操作。</p>
<p>ServerSocket socket()</p>
<p>返回对应的ServerSocket对象。</p>
<p>SocketChannel accept()</p>
<p>接受一个连接，返回代表这个连接的SocketChannel对象。</p>
<p><b>SocketChannel</b></p>
<p>支持异步操作，对应于java.net.Socket这个类，提供了TCP协议IO接口，支持OP_CONNECT，OP_READ和OP_WRITE操作。这个类还实现了ByteChannel，ScatteringByteChannel和GatheringByteChannel接口。</p>
<p>DatagramChannel和这个类比较相似，其对应于java.net.DatagramSocket，提供了UDP协议IO接口。</p>
<p>Socket socket()</p>
<p>返回对应的Socket对象。</p>
<p>boolean connect(SocketAddress remote)</p>
<p>boolean finishConnect()</p>
<p>connect()进行一个连接操作。如果当前SocketChannel是blocking模式，这个函数会等到连接操作完成或错误发生才返回。如果当前SocketChannel是non-blocking模式，函数在连接能立刻被建立时返回true，否则函数返回false，应用程序需要在以后用finishConnect()方法来完成连接操作。</p>
<p><b>Pipe</b></p>
<p>包含了一个读和一个写的channel(Pipe.SourceChannel和Pipe.SinkChannel)，这对channel可以用于进程中的通讯。</p>
<p><b>FileChannel</b></p>
<p>用于对文件的读、写、映射、锁定等操作。和映射操作相关的类有FileChannel.MapMode，和锁定操作相关的类有FileLock。值得注意的是FileChannel并不支持异步操作。</p>
<p><b>Channels</b></p>
<p>这个类提供了一系列static方法来支持stream类和channel类之间的互操作。这些方法可以将channel类包装为stream类，比如，将ReadableByteChannel包装为InputStream或Reader；也可以将stream类包装为channel类，比如，将OutputStream包装为WritableByteChannel。</p>
<p>Package java.nio.charset</p>
<p>这个包定义了Charset及相应的encoder和decoder。下面这张UML类图描述了这个包中类的关系，可以将其中Charset，CharsetDecoder和CharsetEncoder理解成一个Abstract Factory模式的实现：</p>
<p><img border="0" hspace="0" alt="" align="baseline" src="{{ site.baseurl }}/img/o_charset.gif" /></p>
<p><b>Charset</b></p>
<p>代表了一个字符集，同时提供了factory method来构建相应的CharsetDecoder和CharsetEncoder。</p>
<p>Charset提供了以下static的方法：</p>
<p>SortedMap availableCharsets()</p>
<p>返回当前系统支持的所有Charset对象，用charset的名字作为set的key。</p>
<p>boolean isSupported(String charsetName)</p>
<p>判断该名字对应的字符集是否被当前系统支持。</p>
<p>Charset forName(String charsetName)</p>
<p>返回该名字对应的Charset对象。</p>
<p>Charset中比较重要的方法有：</p>
<p>返回该字符集的规范名。</p>
<p>Set aliases()</p>
<p>返回该字符集的所有别名。</p>
<p>CharsetDecoder newDecoder()</p>
<p>创建一个对应于这个Charset的decoder。</p>
<p>CharsetEncoder newEncoder()</p>
<p>创建一个对应于这个Charset的encoder。</p>
<p><b>CharsetDecoder</b></p>
<p>将按某种字符集编码的字节流解码为unicode字符数据的引擎。</p>
<p>CharsetDecoder的输入是ByteBuffer，输出是CharBuffer。进行decode操作时一般按如下步骤进行：</p>
<p>1． 调用CharsetDecoder的reset()方法。（第一次使用时可不调用）</p>
<p>2． 调用decode()方法0到n次，将endOfInput参数设为false，告诉decoder有可能还有新的数据送入。</p>
<p>3． 调用decode()方法最后一次，将endOfInput参数设为true，告诉decoder所有数据都已经送入。</p>
<p>4． 调用decoder的flush()方法。让decoder有机会把一些内部状态写到输出的CharBuffer中。</p>
<p>CharsetDecoder reset()</p>
<p>重置decoder，并清除decoder中的一些内部状态。</p>
<p>CoderResult decode(ByteBuffer in, CharBuffer out, boolean endOfInput)</p>
<p>从ByteBuffer类型的输入中decode尽可能多的字节，并将结果写到CharBuffer类型的输出中。根据decode的结果，可能返回3种CoderResult：CoderResult.UNDERFLOW表示已经没有输入可以decode；CoderResult.OVERFLOW表示输出已满；其它的CoderResult表示decode过程中有错误发生。根据返回的结果，应用程序可以采取相应的措施，比如，增加输入，清除输出等等，然后再次调用decode()方法。</p>
<p>CoderResult flush(CharBuffer out)</p>
<p>有些decoder会在decode的过程中保留一些内部状态，调用这个方法让这些decoder有机会将这些内部状态写到输出的CharBuffer中。调用成功返回CoderResult.UNDERFLOW。如果输出的空间不够，该函数返回CoderResult.OVERFLOW，这时应用程序应该扩大输出CharBuffer的空间，然后再次调用该方法。</p>
<p>CharBuffer decode(ByteBuffer in)</p>
<p>一个便捷的方法把ByteBuffer中的内容decode到一个新创建的CharBuffer中。在这个方法中包括了前面提到的4个步骤，所以不能和前3个函数一起使用。</p>
<p>decode过程中的错误有两种：malformed-input CoderResult表示输入中数据有误；unmappable-character CoderResult表示输入中有数据无法被解码成unicode的字符。如何处理decode过程中的错误取决于decoder的设置。对于这两种错误，decoder可以通过CodingErrorAction设置成：</p>
<p>1． 忽略错误</p>
<p>2． 报告错误。（这会导致错误发生时，decode()方法返回一个表示该错误的CoderResult。）</p>
<p>3． 替换错误，用decoder中的替换字串替换掉有错误的部分。</p>
<p>CodingErrorAction malformedInputAction()</p>
<p>返回malformed-input的出错处理。</p>
<p>CharsetDecoder onMalformedInput(CodingErrorAction newAction)</p>
<p>设置malformed-input的出错处理。</p>
<p>CodingErrorAction unmappableCharacterAction()</p>
<p>返回unmappable-character的出错处理。</p>
<p>CharsetDecoder onUnmappableCharacter(CodingErrorAction newAction)</p>
<p>设置unmappable-character的出错处理。</p>
<p>String replacement()</p>
<p>返回decoder的替换字串。</p>
<p>CharsetDecoder replaceWith(String newReplacement)</p>
<p>设置decoder的替换字串。</p>
<p><b>CharsetEncoder</b></p>
<p>将unicode字符数据编码为特定字符集的字节流的引擎。其接口和CharsetDecoder相类似。</p>
<p><b>CoderResult</b></p>
<p>描述encode/decode操作结果的类。</p>
<p>CodeResult包含两个static成员：</p>
<p>CoderResult OVERFLOW</p>
<p>表示输出已满</p>
<p>CoderResult UNDERFLOW</p>
<p>表示输入已无数据可用。</p>
<p>其主要的成员函数有：</p>
<p>boolean isError()</p>
<p>boolean isMalformed()</p>
<p>boolean isUnmappable()</p>
<p>boolean isOverflow()</p>
<p>boolean isUnderflow()</p>
<p>用于判断该CoderResult描述的错误。</p>
<p>int length()</p>
<p>返回错误的长度，比如，无法被转换成unicode的字节长度。</p>
<p>void throwException()</p>
<p>抛出一个和这个CoderResult相对应的exception。</p>
<p><b>CodingErrorAction</b></p>
<p>表示encoder/decoder中错误处理方法的类。可将其看成一个enum类型。有以下static属性：</p>
<p>CodingErrorAction IGNORE</p>
<p>忽略错误。</p>
<p>CodingErrorAction REPLACE</p>
<p>用替换字串替换有错误的部分。</p>
<p>CodingErrorAction REPORT</p>
<p>报告错误，对于不同的函数，有可能是返回一个和错误有关的CoderResult，也有可能是抛出一个CharacterCodingException。</p>
