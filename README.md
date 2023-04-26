# GCD
> 环境：我们创建两个子线程，然后在子线程中执行队列和任务

#### 创建两个子线程
```
/// 子线程1
let thread1 = Thread {
    for _ in 0..<5 {
      self.read()
    }
}

/// 子线程2
let thread2 = Thread {
   for _ in 0..<5 {
     self.read()
   }
}

print("111 == \(thread1)")
print("222 == \(thread2)")

thread1.start()
thread2.start()
```

### 1. 串行队列 + 同步任务
```
/// 串行队列
let queue = DispatchQueue(label: "com.rw.queue")
/// 执行的任务
func read() {
    /// **同步执行**
    self.queue.sync {
        sleep(1)
        printXY("\(index) read in \(Thread.current)", obj: nil)
    }
}
```
> 打印结果： 
111 == <NSThread: 0x6000003a56c0>{number = 8, name = (null)}
222 == <NSThread: 0x6000003a5240>{number = 9, name = (null)}
23:10:02.671  1 read in <NSThread: 0x6000003a56c0>{number = 8, name = (null)}
23:10:03.675  2 read in <NSThread: 0x6000003a5240>{number = 9, name = (null)}
23:10:04.680  1 read in <NSThread: 0x6000003a56c0>{number = 8, name = (null)}
23:10:05.683  2 read in <NSThread: 0x6000003a5240>{number = 9, name = (null)}
23:10:06.685  1 read in <NSThread: 0x6000003a56c0>{number = 8, name = (null)}
23:10:07.689  2 read in <NSThread: 0x6000003a5240>{number = 9, name = (null)}  

队列是`串行队列`，任务是`同步任务`
从结果看： 
1. 队列中没有创建新的线程(同步任务特征)
2. 从打印时间来看，队列中的任务依次执行(串行队列特征)
---

### 2. 串行队列 + 异步任务
```
/// 串行队列
let queue = DispatchQueue(label: "com.rw.queue")
/// 执行的任务
func read() {
    /// **异步执行**
    self.queue.async {
        sleep(1)
        printXY("\(index) read in \(Thread.current)", obj: nil)
    }
}
```
> 打印结果： 
111 == <NSThread: 0x60000291c580>{number = 8, name = (null)}
222 == <NSThread: 0x60000291eec0>{number = 9, name = (null)}
23:25:35.346  1 read in <NSThread: 0x60000293ea00>{number = 7, name = (null)}
23:25:36.352  1 read in <NSThread: 0x60000293ea00>{number = 7, name = (null)}
23:25:37.353  1 read in <NSThread: 0x60000293ea00>{number = 7, name = (null)}
23:25:38.357  2 read in <NSThread: 0x60000293ea00>{number = 7, name = (null)}
23:25:39.358  2 read in <NSThread: 0x60000293ea00>{number = 7, name = (null)}
23:25:40.362  2 read in <NSThread: 0x60000293ea00>{number = 7, name = (null)}

队列是`串行队列`,任务是`异步任务`
从结果看：
1. 执行异步任务的时候创建了新的线程(异步任务特征)
2. 从打印时间看，队列任务依次执行(串行队列特征)
---
### 3. 并行队列 + 同步任务
```
/// 并行队列
let queue = DispatchQueue(label: "com.rw.queue", attributes: .concurrent)
func read(_ index: Int) {
    /// 同步执行
    self.queue.sync {
        sleep(1)
        printXY("\(index) read in \(Thread.current)", obj: nil)
    }
}
```
> 打印结果：
111 == <NSThread: 0x60000188a000>{number = 7, name = (null)}
222 == <NSThread: 0x600001889c80>{number = 8, name = (null)}
23:44:00.092  1 read in <NSThread: 0x60000188a000>{number = 7, name = (null)}
23:44:00.092  2 read in <NSThread: 0x600001889c80>{number = 8, name = (null)}
23:44:01.095  1 read in <NSThread: 0x60000188a000>{number = 7, name = (null)}
23:44:01.095  2 read in <NSThread: 0x600001889c80>{number = 8, name = (null)}
23:44:02.101  2 read in <NSThread: 0x600001889c80>{number = 8, name = (null)}
23:44:02.101  1 read in <NSThread: 0x60000188a000>{number = 7, name = (null)}

队列是`并行队列`， 任务是`同步任务`
从结果看：
1. 执行同步任务的时候，没有创建新的线程(同步任务特征)
2. 从打印时间看，并行队列中的任务并发执行(可以看到`线程1`和`线程2`的任务并发执行)
---
### 4. 并行队列 + 异步任务
```
/// 并行队列
let queue = DispatchQueue(label: "com.rw.queue", attributes: .concurrent)
func read(_ index: Int) {
    /// 异步执行
    self.queue.async {
        sleep(1)
        printXY("\(index) read in \(Thread.current)", obj: nil)
    }
}
```
> 打印结果：
111 == <NSThread: 0x600001699780>{number = 8, name = (null)}
222 == <NSThread: 0x600001699c40>{number = 9, name = (null)}
23:48:52.496  2 read in <NSThread: 0x60000168cb40>{number = 12, name = (null)}
23:48:52.496  1 read in <NSThread: 0x6000016a9380>{number = 11, name = (null)}
23:48:52.496  1 read in <NSThread: 0x60000168ab40>{number = 4, name = (null)}
23:48:52.496  2 read in <NSThread: 0x600001694980>{number = 13, name = (null)}
23:48:52.496  2 read in <NSThread: 0x600001698a80>{number = 14, name = (null)}
23:48:52.496  1 read in <NSThread: 0x600001695b00>{number = 10, name = (null)}

队列是`并行队列`， 任务是`异步任务`
从结果看：
1. 执行异步任务的时候，创建了新线程
2. 从打印时间看，并行队列的任务并发执行
---
### 总结
`并行和串行主要影响：任务的执行方式`
- 串行队列： 添加到队列里面的任务，任务依次执行
- 并行队列： 添加到队列里面的任务，任务并发执行

`同步和异步主要影响：能不能开启新的线程`
- 同步执行： 在当前线程中执行任务，不具备开启新线程的能力
- 异步执行： 在新的线程中执行任务，具备开启新线程的能力

对于情况2（串行队列 + 异步任务）和情况3（并行队列 + 同步任务），很多时候会很迷惑，我们只要理解了`队列`和`任务`的影响就会理解。
这是鄙人对 GCD 的一些浅薄看法，能力有限，如有不对的地方，欢迎指正。
