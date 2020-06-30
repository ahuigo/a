---
title: make
date: 2018-09-27
---
# 引用
引⽤用类型包括 slice、map 和 channel。

    // 提供初始化表达式。
    a := []int{0, 0, 0}
    a[1] = 10

# new make
1. new 负责分配内存，new(T) 返回`*T` 指向一个零值 T 的指针
2. make 负责初始化值，make(T) 返回初始化后的 T ，而非指针

## new: *T
new 的作用是:为其分配零值内存, 初始化一个指向类型的指针 `(*T)`，
`someInt := new(int)` 相当于:

    func newInt *int {
        var i int
        return &i; //golang 和 c 语言不一样，栈区分配的存储空间不会随着函数的返回而释放，本地变量地址所占据的存储空间会生存下来。 
    }
    someInt := newInt()

new 返回Pointer(数组就是指针)

	// Error: invalid operation: c[1]
	c := new([]int) // var i []int => *[]int
	c[1] = 10

    // ok
	c := new([3]int) // var i [3]int => *[3]int
	c[1] = 10

## make
最重要的一点：make 仅适用于slice，map 和channel

    ch := make(chan int)
    ch := make(chan string)

    m := make(map[int]int)
    m := make(map[string]int)

static size

    slice := make([]int, 3)
        []int{0, 0, 0}

slice cap:

    make([]Type, length, capacity)