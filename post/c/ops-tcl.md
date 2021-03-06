---
layout: page
title:	学习一下 Tcl/Tk
category: blog
description:
---
# Preface
之前一直在使用expect，但对其背后的语言(Tcl/Tk) 不了解。由于工作中需要对一些交互式的程序做自动控制，所以就系统的学习一下Tck/Tk 的语法.

Expect 是Tcl/Tk 最有名的扩展.  Tcl/Tk 是很小众的语言，如果你想实现对工具的自动控制，这门语言将帮助你高效完成这些事.

> Tcl 是工具控制语言（Tool Command Language）的缩写, Tk 是Tcl "图形工具箱" 扩展，提供了各种标准的GUI 接口.

# Background
John K. Ousterhout 于1988 年开发了Tcl/Tk.  Ousterhout 博士离开UCB(加州大学伯克利分校) 后继续改进了改语言, 目前稳定的版本是8.5

Tck/tk 以可扩展性、学习曲线短、易于嵌入为目标而设计的。 Tck/tk 包括两个命令: `tclsh` 和 `wish`, `tclsh` 是tcl interpreter for command, 而`wish` 是 tcl interpreter for GUI. 它们都是tcl 的外壳

Mac OSX 和大部分Linux 已经内置了tcl/tk，你可通过以下命令确认：

	➜  tool git:(master) ✗ l `which wish`
	lrwxr-xr-x  1 root  wheel     7B Nov 24 18:54 /usr/bin/wish -> wish8.5
	➜  tool git:(master) ✗ l `which tclsh`
	lrwxr-xr-x  1 root  wheel     8B Nov 24 18:54 /usr/bin/tclsh -> tclsh8.5

Tcl/Tk 可以通过编译的c 函数来扩展Tcl 解释器，可从Tcl 环境内部调用Tcl 解释器扩展。Expect 就是一个非常流行的Tcl 解释器扩展

# Statement
tcl 语句以换行`\n`、`;` 分隔，以`#` 注释. 以`\ ` 转义换行符

# IO

## Io Line
Tcl 按行(line)读写IO 的命令是`gets`, `puts`:

	gets <fd> <varname>; # with no line, return number of chars
	puts [<fd>] <string>; # with new newline
		fd: The default fd is stdout

> 如果不想输出换行，应该使用 `puts -nonewline $varname`

### stdout

	~/tcltk$ cat hello.tcl
	#!/usr/bin/tclsh
	puts stdout "Hello, World!\n"
	puts stdout {Hello, World!\n}

	~/tcltk$ ./hello.tcl
	Hello, World!
	Hello, World!\n

> 默认的stdout 是可以省略的

	puts stderr "Some error"

### stdin

	gets stdin line # with no newline
	puts stdout $line

	while {[gets stdin Line] > 0} {
		puts stdout $Line
	}

## Io char
Refer to: http://wiki.tcl.tk/14693

	proc enableRaw { {channel stdin} } {
	   exec /bin/stty raw -echo <@$channel
	}
	proc disableRaw { {channel stdin} } {
	   exec /bin/stty -raw echo <@$channel
	}

	enableRaw
	set c [read stdin 1]
	puts -nonewline $c
	disableRaw

# String

	'string' 相当于 "'string'", 也就是说单引号是特殊的字符
	"string" 双引号才是字符的边界
	string	不含关键字的字符，也不需要字符边界。但是为了避免解析器干扰，还是应该使用双引号的

示例

	% set Phrase "hello, world!"
	hello, world!

	% string length $Phrase
	14
	% string length "中国" # utf8
	6
	% string length "中国"
	2

## string case

	% string toupper $Phrase
	HELLO, WORLD!

	% string totitle $Phrase
	Hello, world!

## string match
wildcard match

	% string match ello $Phrase
	0

	% string match *ello* $Phrase
	1

	% if {"a">"A"} {puts stdout yes}
	yes

## string replace
replace 和 map 来处理的。后者需要预先定义一个字符映射表。用 range 抽取子字符串，用 repeat 多次输出字符串。

map 相当于php replace，replace 相当于php 中的substr

	% string replace "this is a bad example" 10 12 good
	this is a good example

	% string map {bad good} "this is a bad example"
	this is a good example

## format
format 类似c printf 语法

	% format "%.2f seconds to execute" 3.14

## scan

	scan string format ?varName varName ...?

Example:

	% scan "12 23 25" "%2d %2d %2x" r g b
	3
	% puts $r
	12
	% puts $g
	23
	% puts $b
	37

## append(concat)

	% append Phrase "Nice day, eh?"
	hello, world!
	Nice day, eh?

## index
执行 index、last、first、wordend 和 wordstart 命令可以实现下标功能

	% string wordend $Phrase 7
	12

## trim
字符串修改是由trim、trimleft、trimright 完成

	% string trimleft " abc "
	abc
	% string trimleft "abc,abd,;" ",;"
	abc,abd

# 元字符
Tcl 元字符 是指字符关键字，它们包括分组语句、封装字符串、终止语句以及其它

	; 或newline	语句分隔符
	Name		变量（区分大小写）
	Name(idx)	数组变量
	Name(j,k,l...)	多维数组
	"string"	带替换的引用
	$var		等价于"$var"
	{string}	不带替换的引用
	[string]	命令替换
	\char		反斜杠替代
	\			行继续（在行尾）

Example:

	set a 2
	set b 3
	puts stdout "$a$b"
	puts stdout {$a$b}
	puts stdout "$a*$b=[expr $a*$b]"

	//output:
	23
	$a$b
	2*3=6

转义:

	puts "\[expr 1+3\]"

## Double Quotes
Double Quotes 下会转义

	$var
	\	会合并换行后的空白符
	\a	响铃
	\b	退格
	\f	换页
	\n 或 \newline	新行
	\r	回车
	\t	水平制表
	\v	垂直制表
	\space ("\ ")	空格
	\ddd	八进制值
	\xddd...	十六进制值
	\c	回显‘c’
	\\	反斜杠

# Number & Math

## Number

	set n 1
	incr n
	incr n -1

## Math
Tcl 使用expr 关键字实现数学运算

	expr 3*5
	set n 1
	set n [expr n+1]
	set PI [expr 2 * asin(1.0)]

数学函数:

	三角函数包括 cos(x)、acos(x)、cosh(x)、sin(x)、asin(x)、sinh(x)、tan(x)、atan(x)、atan2(y, x)、tanh(x) 和 hypot(x, y)。与这些函数相关的单位是弧度。
	Log 函数是 exp(x)、log(x) 和 log10(x)。
	算术函数是 ceil(x)、floor(x)、fmod(x, y)、pow(x, y)、abs(x)、int(x)、double(x) 和 round(x)。
	rand() 和 srand(x) 是处理随机数的函数。

### expr
> https://www.tcl.tk/man/tcl8.5/TclCmd/expr.htm

	- + ~ !
	**
	* / %
	+ -
	<< >>
	< > <= >=
	== !=
	eq ne
	in ni
	&
	^
	|
	&&
	||
	x?y:z

# List
Tcl 支持列表(List) 与数组(Array). 它们是不同的数据结构

两种定义列表的方法: 一个是`{}` 一个是`list`

	% set c1 {Bob Carol}
	Bob Carol
	% set c1 {
		Bob
		Carol
	}
	Bob Carol
	% set c2 [list Bob Carol]
	Bob Carol

	# compare
	% if {$c1==$c2} {puts "equal"}
	equal

list 可以是多维的

	% set Party1 [list $c1 {Ted Alice} {b}]
	{Bob Carol} {Ted Alice} b

## list concat
list 也可以concat

	% set Party2 [concat $c1 {Ted Alice} {b}]
	Bob Carol Ted Alice b

## list insert
将字符串"sth." 插入到list 的第一个位置

	% linsert { {a b} {c d} } 1 sth.
	{a b} sth. {c d}

## list split and join
split 命令将字符串作为输入并生成经过正确解析的列表，并且在指定的字符处断开字符串。

	% split a,b,c,d ,
	a b c d

join 执行相反操作，接受列表元素并将它们串在一起，用 joinstring 分隔它们。

	% join {a b c d} ,
	a,b,c,d

## list search
list 支持 lreplace、lsearch 和 lsort。

	% lsearch {a b c d1} d1
	3

lreplace 有点像

	% lreplace $list $start $end $replace
	% lreplace {a b c d1} 2 3 {c1 c2}
	a b {c1 c2}

## list more cmd

	llength $List ― 返回顶级项的计数结果。
	lindex $List n ― 返回已建立下标的项，从 0 开始计数。
	lrange $List i j ― 返回下标[i,j]范围 的元素。
	lappend $List item... ― 将项附加到列表。
	linsert $List n item... ― 在列表中的指定位置上插入一项或多项，向下移列表中的其它项。

argv 是一个列表List, 使用下标(lindex) 访问指定的list元素

	set param0	[lindex $argv 0]
	set param1	[lindex $argv 1]
	puts stdout "script: $argv0, params: $param0 $param1"

## list foreach
list 遍历需要`foreach`

	foreach Arg $argv {
		puts "$Arg\n"
	}

# Array
Tcl Array不同于list, 从数据结构来说tcl list 才是数组，而tcl Array 是hash 表

	$ cat e.tcl
	set user(id) 1
	set user(name) hilo

	% puts $user(name)
	hilo

	% array names user
	name id

	% array size user
	2

	% set user(feeds) {1 2 3}

## Array exists
测试变量是否是数组

	% array exists user
	1
	% array exists user1
	0

## element exists

	puts [info exists user(id)] # 1 if exists or 0 if not exists

## Array get/set
array get将array 转为list(包括key, key in random order)

	% array get user
	name hilo id 1

array set 用于将list(even number) 转为array

	array set val [list a 1 c 6 d 3]
	 puts $val(c)
	 6

## array loop
遍历整个数组有它自己的一组四个命令: (tcl 的array loop 很恶心，居然叫search!)

	array startsearch 初始化遍历
	array anymore 	是否还有元素
	array nextelement 指向下一元素
	array donesearch 释放遍历分配的内存


Example:

	array set test {0 a 1 b 2 c 3 d 4 f} ;# create an array.
	array get test ;# prints the array to show it is in random order

	set srch [array startsearch test]
	while {[array anymore test $srch]} {
	   set key [array nextelement test $srch]
	   puts "test($key) = $test($key)"
	}
	array donesearch test $srch ;# releases temporary memory associated with the search

The "array get test" returns:

	4 f 0 a 1 b 2 c 3 d

The loop prints:

	test(4) = f
	test(0) = a
	test(1) = b
	test(2) = c
	test(3) = d

这样遍历更简单:

	while {[set key [array nextelement test $srch]] ne ""} {puts $test($key)}
	while {[set key [array nextelement test $srch]] != ""} {puts $test($key)}

或者借用 `array names`

	proc show_array arrayName {
		upvar $arrayName myArray
		foreach key [array names myArray] {
		   puts "${arrayName}($key) = $myArray($key)"
		}
	}
	set arval(0) zero
	set arval(1) one
	show_array arval

## Array multidimension
虽然设计之初 Tcl 数组是一维的(它可以嵌入list 这条不算多维), 但是可以模拟多维(multidimension)

因为下标是任意字符串，所以二维数组可以声明如下：

	set i 1 ; set j 10

	set array($i,$j) 3.14159
	incr $j
	set array($i,$j) 2.71828

# Condition Expression
if/elseif/else 和 switch 提供条件判断，
限定语句是 break、continue、return 和 error,
catch 命令提供了错误处理能力。

	if { [catch {open $someFile w} fid] } {
	   puts stderr "Could not open $someFile for writing\n$fid"
	   exit 1
	} elseif ($a-$b > 0) {

	} else {$a==0} {

	}

## if
注意下if 后没有空白符做间隔`if{condtion}{` 或者`if {condition}{` 都是不可以的, `if {$argc>=1}` 是可以的
`if {condition}`

	if {$argc >= 1} {
		puts stdout "script name: $argv0 $argv1\n"
	} elseif { $a==0 } {
		puts stdout "script name: $argv0\n"
	} else {$a eq '0'}{

	}

`'0' == 0` 是相等的

`(condition)` 都是也可以的.
不过 `($a == 0)` 会被解析为`(0`、`==`、`0)` 而导致错误，`( $a==0 )` 导致解析错误。 所以不要带空格, 即`($a==0)`

	% if ($argc == 0) {send_user abc}
	unbalanced open paren
	in expression "(0"

## switch
switch 支持`-glob` (一种通配符) 与 `-re`(Posix 正则), `--` 好像是用于指示后面的是普通参数？好像可以省略

glob:

	set Arg [lindex $argv 0]
	switch -glob -- $Arg {
		-o*end {puts stdout "^-o.*end$"}
		-v*end {puts stdout "^-v.*end$"}
		default {
			error "Unknown $Arg"; # 带exit
		}
	}

switch with posix regex:

	set arg [lindex $argv 0]
	puts stdout $arg
	switch -re "$arg" {
		a[[:space:]]+b {puts stdout "posix regex: 'a\s+b'"}
		default {
			error "Unknown $arg"
		}
	}

# regex

	-re 标志调用 regexp 匹配，
	-ex 表明必须是精确匹配，
	-glob 通配符 默认

expect 的其它可选标志包括 -i 和 -nocase，前者表示要监控产生的进程，后者强迫在匹配之前将进程输出变为小写。
对于完整的说明，在命令提示符下输入 man expect，以查看 Expect 的系统手册页面文档。

# Loop Expression

## while

	while {[set key [array nextelement test $srch]] != ""} {
		...
	}

## for

	for {initialization} {conditions} {incrementation or decrementation} {

	}
	for {set j 0} {$j < 5} {incr j} {
		do something
	}

## foreach(list)
for list

	foreach Arg $argv {
		puts stdout "$Arg\n"
	}

# Procedure
Tcl 过程(proc)，它相当于php 或shell 的函数

Proc 内的变量是局部的，如果需要全局的则需要使用global, 这一点类似php

	set PI [expr 2 * asin(1.0)]
	proc circum {rad} {
		global PI
		return [expr 2.0 * $rad * $PI]
	}
	set rad 5
	% circum $rad
	31.41592653589793

> `{rad}` 参数是一个list, list 只有一个元素时，可以不用加`{}`, 即`rad`

如果需要默认参数:

	proc add { {a 100} {b 200} } {
		return [expr $a+$b]
	}
	puts [add 1 2]; # 3
	puts [add]; # 300

## scope
upvar 可以使局部变量同另一作用域的变量绑定(引用):

	upvar level $VarName LocalVar

其中 level 是到当前作用域之外的步骤数。0 表示本层，即当前作用域，1 就是上一层。“#0”表示全局作用域这一层。

To set a variable in the caller:

	proc someproc varname {
		upvar 1 $varname var
		set var 5
	}
	someproc a
	set a ;# -> 5

global:

	upvar #0 foo foo  ;# equivalent to: global foo

Link to another variable in the same execution frame  edit

	upvar 0 foo bar  ;# assigns alias 'bar' to a local variable 'foo'. Both foo and bar point to same value

upvar with Array:

	proc show_array arrayName {
		upvar $arrayName myArray

		foreach element [array names myArray] {
		   puts stdout "${arrayName}($element) = $myArray($element)"
		}
	}

	set arval(0) zero
	set arval(1) one
	show_array arval

> 如果不指定level，它会自动向上查找
> 注意下varname in string, `${varname}($element)`

## rename
rename 用于重命名过程：它可以实现过程别名，或者过程重新定义

	1. rename exec exec_alias;
	1. rename exec {}; #可以防止用户执行外部命令。

# Inner Variable

	env 	array: $env[HOME]
	argc	number
	argv	自变量的list(参数list)
	argv0	scriptName
	errorCode 存储有关最近的 Tcl 错误信息，
	errorInfo 包含对这同一个错误事件的堆栈跟踪。

> 该列表还有另外 12 个 tcl_xxx 变量，从 tcl_interactive 到 tcl_version。可以在 Tcl/Tk in a Nutshell 中找到好的总结

# File adn Path

	% file exists a.txt
	1
	% file executable a.txt
	0
	% file pathtype a.txt
	relative
	% file delete a.txt

file join 命令用于将 UNIX 格式转换成本机路径名。其它路径字符串命令包括 file split、dirname、file extension、nativename、pathtype 和 tail。

	% file join /home hilo test
	/home/hilo/test
	% file dirname /a/b/c.txt
	/a/b
	% file split /a/b/c.txt
	/ a b c.txt
	% file extension /a/b/c.txt
	.txt

## file mode
Tcl 有许许多多种内部文件测试和操作功能。每条命令都以 file 开始，正如 file exists name 中一样。其它测试命令（它们都返回布尔值）包括 executable、isdirectory、isfile、owned、readable 和 writable。

## directory operator
文件信息和操作（再提醒您一次，所有都是以 file 开始）是通过 atime、attributes、copy、delete、lstat、mkdir、mtime、readlink、rename、rootname、size、stat 和 type 来完成。

	% file stat a.txt a
	% foreach i [array names a] { puts "$i : $a($i)" }
	type : file
	size : 4
	mtime : 1432484782
	ino : 41872062
	dev : 16777220
	atime : 1432484782
	uid : 501
	ctime : 1432484782
	nlink : 1
	gid : 20
	blksize : 4096
	mode : 33188
	blocks : 8

请注意，在 Windows 或 Mac 环境中运行一些文件信息命令时，可能会返回未定义的数据，因为例如在那些文件系统中没有表示索引节点和符号（和硬）链接数据。

> 也可以使用`exec shell_cmd` 代替file. 不过使用 file ... 命令而不使用通过 exec 的本机命令的好处在于，前者会提供一个可移植接口。

# tcl cmd
tcl 可以直接执行大部分外部命令(shell cmd)，比如下面的date, nslookup
也可以用`exec` 显式的执行所有的外部命令, exec 程序可以充分利用 UNIX 环境中的 I/O 重定向和管道。

tcl 执行命令的返回遵守一些规则:

- tcl 交互环境，命令的输出被直接定向到屏幕的stdout
- tcl 处于非交互环境时，或者使用exec时，命令的输出会返回给tcl, 这允许将程序返回赋值给变量.

	% set d [date]
	Mon May 25 11:37:56 CST 2015
	% puts $d

	% set d [exec date]
	Mon May 25 11:38:04 CST 2015
	% puts $d
	Mon May 25 11:38:04 CST 2015

- 不过当程序在后台执行时，返回值是程序的PID `set pid [exec ls &]`

## file
文件操纵使用下列命令：open、close、gets、puts、read、tell、seek、eof 和 flush。

### open

	% open a.txt r
	file17
	% gets file17
	line1
	% close file17

或者 open:

	% set fd [open a.txt r]
	% gets $fd


在文件打开命令期间 catch 命令对错误检查是有用的。

	if [catch {open foo r} fd] {
		error "Failed to open foo for reading\n $fd"
	}

当在遇到新的一行字符之前需要打印程序输出时，如在用户数据提示符中，使用 flush 来写输出缓冲区。

## file read

	% read [open a.txt r]
	line1
	line2

## date

	% date
	Mon May 25 11:21:01 CST 2015
	% exec date
	Mon May 25 11:21:06 CST 2015

unixstamp

	% clock seconds
	1432537015

## eval

	set cmd "expr 1+3"
	puts [eval $cmd]; # 4

	puts [eval expr 5*5] # 25

## dns

	% nslookup ahuigo.github.io
	...
	% exec nslookup ahuigo.github.io
	...

# TK 命令
Tk 是对Tcl 的图形工具扩展, Tk 主要用于编写简单的GUI 脚本

> 如果你需要了解Tk 用法，请参考[tcl/tk-ibm] 及其附录

## Button

	#!/usr/bin/wish
	#
	# Hello World, Tk-style
	button .hello -text Hello \
	  -command {puts stdout \
	  "Hello, World!"}
	button .goodbye -text Bye! \
	  -command {exit}

	pack .hello -padx 60 -pady 5
	pack .goodbye -padx 60 -pady 5

这时用`button` 创建了两个按钮小部件，用`pack ` 将按钮放到窗口(同时会将窗口缩放到合适大小)，而`place` 则不会

	button <buttonName> -text <text> -command {cmds}
	pack <buttonName> -padx <x> -pady <y>

## Tk 小部件
在创建 Tk 小部件时，几乎很少使用命令。一半以上都是按钮或文本小部件的变体，如下面的列表所示。其中几项在下一屏中演示。

	button ― 有二十多种配置选项（从 anchor 和 font 到 padx 和 relief）的简单小部件。
	canvas ― 画布是一种小部件，不仅可以包含其它小部件，而且包含各种类型的结构化图形，包括圆、线和多边形。
	checkbutton ― 创建复选框样式的按钮小部件，它链接到一个变量。
	entry ― 构建单行文本输入框。
	frame ― 框架是主要用作容器或定位架的小部件。
	label ― 创建标签对象。
	listbox ― 创建文本字符串列表框。在定义小部件之后，添加各项。
	menu ― 单个多面小部件，包含多种菜单样式的各种项。
	menubutton ― 为下拉菜单实现提供可单击的顶级界面。
	message ― 创建包括版本调整和字自动换行特性的文本显示窗口小部件。
	radiobutton ― 创建单选按钮，它可以是与指定变量相关的一个集合之一。
	scale ― 为在指定范围和分辨率内选择值而创建滑动块。
	scrollbar ― 为在相关小部件中更改部分内容（通常是文本或图）而生成小部件。
	text ― 创建显示一个或多个文本行并允许编辑该文本的小部件。
	toplevel ― 创建新的顶级（在 X 桌面上）窗口。

# Reference
- [tcl/tk-ibm]
- [expect manual]

[tcl/tk-ibm]: http://www.ibm.com/developerworks/cn/education/linux/l-tcl/l-tcl-blt.html
[expect manual]: http://linux.die.net/man/1/expect
