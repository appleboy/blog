---
title: "用 Go 語言實現固定大小的 Ring Buffer 資料結構"
date: 2023-01-24T08:08:14+08:00
draft: true
author: appleboy
type: post
slug: ring-buffer-queue-with-fixed-size-in-golang
share_img: https://i.imgur.com/mDJolWF.png
categories:
  - Golang
  - Data Structure
---

![logo](https://i.imgur.com/mDJolWF.png)

Ring Buffer Queue 是**固定大小記憶體**的 FIFO (first in, first out) 資料結構，用來處理不同 Process 之前的資料交換。工作原理就是在一段連續固定大小區間的記憶體用 (head/tail) 兩個指針來決定現在要將資料放在哪個位置。本篇將帶大家用 [Go 語言][1]快速實現 Ring Buffer 資料結構。

[1]:https://go.dev

<!--more-->

## 使用時機

由於是固定大小的 Queue，在嵌入式系統領域非常好用，尤其時記憶體非常小的時候，使用上格外小心，因此開發者通常會宣告固定大小來儲存數據，而非使用動態分配，避免系統記憶體被用完。

必須要知道此資料結構也是有限制的，固定大小的 Queue，最終會遇到資料滿的時候該如何處理，有兩種方式，第一種就是將最新的資料拋棄，另一種就是將最新的資料繼續寫入舊的記憶體區段。

## 實作原理

從 [Wiki][11] 上面看到底下這張動畫圖

![circular buffer](https://i.imgur.com/uGdFrWI.png)

從上圖可以看到在資料結構內需要底下成員

* buf: 內容儲存格式
* capacity: 固定容量大小 (length)
* head: 指向從 Buffer 內取出資料 (start)
* tail: 指向從 Buffer 內儲存資料 (end)

API 實作細節需要底下四個函示

* Enqueue: 將資料放入 Queue
* Dequeue: 從 Queue 讀取資料
* IsEmpty: 判斷 Queue 內是否有資料
* IsFull: 判斷 Queue 是否已經滿了

[11]:https://en.wikipedia.org/wiki/Circular_buffer

## 如何實作

根據上述的資料結構，可以用 Go 語言宣告如下

```go
type T interface{}

type CircularBuffer struct {
  sync.Mutex
  taskQueue []T
  capacity  int
  head      int
  tail      int
}
```

實作判斷 `IsEmpty`，是否為空，只要是 `head` 跟 `tail` 值相同的話，就是空的。資料結構初始化後，head 跟 tail 就都為零。

```go
func (s *CircularBuffer) IsEmpty() bool {
  return s.head == s.tail
}
```

實作判斷 `IsFull` 是否已經滿了，無法在寫入資料，當有新資料寫入時，tail 就會 +1，而 head 則是維持不動。等到 Queue 寫入到最後一個空間後，`tail + 1` 就會等於 head 值，而由於是 Ring 結構，所以需要除以 `capacity` 取餘數。這邊請注意，由於要計算是否已經滿了，故需要浪費掉一個位置來確認。

```go
func (s *CircularBuffer) IsFull() bool {
  return s.head == (s.tail+1)%s.capacity
}
```

假設 buffer size 為 4 好了

```sh
# 初始化
head: 0, tail: 0
# 寫入資料
head: 0, tail: 1
# 寫入資料
head: 0, tail: 2
# 寫入資料
head: 0, tail: 3
# Queue 裡面只有三個了
# IsFull() 已經為 true
```

接著看看如何實作 Enqueue 及 Dequeue

```go
func (s *CircularBuffer) Enqueue(task T) error {
  if s.IsFull() {
    return errMaxCapacity
  }

  s.Lock()
  s.taskQueue[s.tail] = task
  s.tail = (s.tail + 1) % s.capacity
  s.Unlock()

  return nil
}

func (s *CircularBuffer) Dequeue() (T, error) {
  if s.IsEmpty() {
    return nil, queue.ErrNoTaskInQueue
  }

  s.Lock()
  data := s.taskQueue[s.head]
  s.head = (s.head + 1) % s.capacity
  s.Unlock()

  return data, nil
}
```

可以看到上述代碼實作方式相同，Enqueue 就是將 `tail+1`，而 Dequeue 就是將 `head+1`。最後補上 New 函式

```go
func NewCircularBuffer(size int) *CircularBuffer {
  w := &CircularBuffer{
    taskQueue: make([]T, size),
    capacity:  size,
  }

  return w
}
```

驗證上述程式碼，底下是測試代碼

```go
func TestQueue(t *testing.T) {
  size := 100
  q := NewCircularBuffer(size)

  for i := 0; i < (size - 1); i++ {
    assert.NoError(t, q.Enqueue(i+1))
  }
  // can't insert new data.
  assert.Error(t, q.Enqueue(0))
  assert.Equal(t, errFull, q.Enqueue(0))

  for i := 0; i < (size - 1); i++ {
    v, err := q.Dequeue()
    assert.Equal(t, i+1, v.(int))
    assert.NoError(t, err)
  }

  _, err := q.Dequeue()
  // no task
  assert.Error(t, err)
  assert.Equal(t, errNoTask, err)
}
```

上面可以看到先宣告 100 size 的 Slice，但是只能使用 99 大小，第 100 個要塞入就會出現錯誤。[程式碼請參考][22]，測試程式碼[請參考這邊][23]

[22]:https://github.com/go-training/training/blob/fcfcb5490a30f0e36a82d0f72fd59a7bfe5181c7/example52-ring-buffer-queue/queue.go#L1-L64
[23]:https://github.com/go-training/training/blob/fcfcb5490a30f0e36a82d0f72fd59a7bfe5181c7/example52-ring-buffer-queue/queue_test.go#L1-L30

## 解決浪費單一空間

上面有提到此 Ring buffer 需要浪費一個空間來計算 Empty 或 Full。來看看怎麼解決這問題，其實很簡單，在資料結構內多新增一個 `full` 變數來確認 Queue 是否為滿。

```diff
type CircularBuffer struct {
  capacity  int
  head      int
  tail      int
+ full      bool
}

func (s *CircularBuffer) IsEmpty() bool {
- return s.head == s.tail
+ return s.head == s.tail && !s.full
}

func (s *CircularBuffer) IsFull() bool {
- return s.head == (s.tail+1)%s.capacity
+ return s.full
}

func (s *CircularBuffer) Enqueue(task T) error {
  s.Lock()
  s.taskQueue[s.tail] = task
  s.tail = (s.tail + 1) % s.capacity
+ s.full = s.head == s.tail
  s.Unlock()

  return nil
}

func (s *CircularBuffer) Dequeue() (T, error) {

  s.Lock()
  data := s.taskQueue[s.head]
+ s.full = false
  s.head = (s.head + 1) % s.capacity
  s.Unlock()
```

## 效能測試

測試代碼如下

```go

func BenchmarkCircularBufferEnqueueDequeue(b *testing.B) {
  q := NewCircularBuffer(b.N)

  b.ReportAllocs()
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    _ = q.Enqueue(i)
    _, _ = q.Dequeue()
  }
}

func BenchmarkCircularBufferEnqueue(b *testing.B) {
  q := NewCircularBuffer(b.N)

  b.ReportAllocs()
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    _ = q.Enqueue(i)
  }
}

func BenchmarkCircularBufferDequeue(b *testing.B) {
  q := NewCircularBuffer(b.N)

  for i := 0; i < b.N; i++ {
    _ = q.Enqueue(i)
  }

  b.ReportAllocs()
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    _, _ = q.Dequeue()
  }
}
```

透過 GitHub Action 測試結果如下

```sh
goos: linux
goarch: amd64
pkg: github.com/go-training/training/example52-ring-buffer-queue
cpu: Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz
BenchmarkCircularBufferEnqueueDequeue
BenchmarkCircularBufferEnqueueDequeue-2     21792045          57.14 ns/op         7 B/op         0 allocs/op
BenchmarkCircularBufferEnqueue
BenchmarkCircularBufferEnqueue-2            34254517          37.20 ns/op         7 B/op         0 allocs/op
BenchmarkCircularBufferDequeue
BenchmarkCircularBufferDequeue-2            54213112          22.14 ns/op         0 B/op         0 allocs/op
```

最後程式碼[請參考這邊](https://github.com/go-training/training/blob/2375f8bce5c7e0740f23a13e786af22f5f2d2fb6/example52-ring-buffer-queue/queue.go#L1)，測試代碼[請參考這裡](https://github.com/go-training/training/blob/2375f8bce5c7e0740f23a13e786af22f5f2d2fb6/example52-ring-buffer-queue/queue_test.go#L9-L30)
