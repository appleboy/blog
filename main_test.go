package main

import (
	"bytes"
	"math/rand"
	"testing"
	"unsafe"
)

const letterBytes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

func randomString(n int) string {
	b := make([]byte, n)
	for i := range b {
		b[i] = letterBytes[rand.Intn(len(letterBytes))]
	}
	return string(b)
}

var buf bytes.Buffer

func b2s(b []byte) string {
	return *(*string)(unsafe.Pointer(&b))
}

func parseMultipleValue(n int, str string) string {
	buf.Reset()
	for i := 0; i < n; i++ {
		buf.WriteString(str)
	}
	s := make([]byte, len(buf.Bytes()))
	copy(s, buf.Bytes())
	return b2s(s)
}

func parseMultipleValue2(n int, str string) string {
	buf.Reset()
	for i := 0; i < n; i++ {
		buf.WriteString(str)
	}

	return buf.String()
}

func benchmark(b *testing.B, f func(int, string) string) {
	str := randomString(10)
	b.ReportAllocs()
	for i := 0; i < b.N; i++ {
		f(10000, str)
	}
}

func BenchmarkA(b *testing.B) { benchmark(b, parseMultipleValue) }
func BenchmarkB(b *testing.B) { benchmark(b, parseMultipleValue2) }
