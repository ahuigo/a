---
title: Ruby
date: 2019-02-17
private:
---
# string
单引号字面义（类似php）

    'a\nb'

双绰号转义：

    "a\nb"
    "#{prefix}"

## concat

    dir = Dir.home+"/www"
    dir = "#{Dir.home}/www"



# shell

## 跳脱符
支持`*`

    # 输出代码字符串
    p `ls -la`

    # escapes newline chars
    printf `ls -la`

exec with variable

    cmd = "ls #{ENV['HOME']}/www"
    `echo #{cmd}`

## system
只支持参数, 没有返回数据

    # 只返回true/false(like python: os.system)
    system "ls", "-la"

    # wrong *
    system "ls", "*"
    # ok
    printf `ls -la *`


## env
HOME:

    print "#{ENV['HOME']}"
    print Dir.home

ENV 可以被改变

    system("echo $PATH")
    ENV['PATH'] = '/nothing/here'
    system("echo $PATH")

# Array
    arr = 'a\nb',"a\nb"

# io

    # print raw
    p 1,2,3
    # print text
    puts 1,2,3

# Ruby Block
写brew cask 包时遇到奇怪的语法`Cask "package-name" do ... end`，原来这就是ruby 的block 呀！

    def test(j)
        p j
        yield 5
        puts "在 test 方法内"
        yield 100
    end
    test 1 do |i| 
        puts "你在块 #{i} 内"
    end

output:

    1
    你在块 5 内
    在 test 方法内
    你在块 100 内

# hash
string key

    grades = { "Jane Doe" => 10, "Jim Doe" => 6 }

symbol key

    options = { font_size: 10, font_family: "Arial" }
    options = { :font_size => 10, :font_family => "Arial" }
    options[:font_size]

symbol value:

    options = {:key=>:value}
    options[:key]==:value

# class 
静态方法与动态方法

    class A
        def self.func1
            puts "static func1"
        end
        def func2
            puts "new.func2"
        end
    end

    A.func1
    A.new.func2

## class extend
下面两个例子snippet 等价， 都将打印“HELLO”。 `make_hello_method`是静态方法

    class Foo
        def self.make_hello_method
            class_eval do
                def hello
                    puts "HELLO"
                end
            end
        end
    end

    class Bar < Foo # snippet 1
        puts "exec before new"
        make_hello_method
    end

    class Bar < Foo; end # snippet 2

比较下静态和动态方法

    Bar.make_hello_method
    Bar.new.hello
    Bar.new.func2

class_eval方法也接受一个String，所以当创建一个类时，可以随时创建方法，它基于传入的参数具有不同的语义。