# Basic program (main.go)
```
package main

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) != 2 {
		os.Exit(1)
	}
	fmt.Println("It's over", os.Args[1])
}
```

# Declarations

#### Variable declaration
```
var power int                // create and assign to 0
var power int = 9000         // create and assign
power := 9000                // can infer the type
```

#### Function declaration
```
func log(message string) {
}

func add(a int, b int) int {
}

func power(name string) (int, bool) {
}

value, exists := power("test")
if exists == false {
	// handle this error case
}
```

#### Struct declaration
```
type Person struct {
	Name string
	Age int
}

ex := Person{
	Name: "Example",
	Age: 20,
}
ex.Age = 30
```

#### Pass by pointer (otherwise by default is pass by copy)
```
func main() {
	ex := &Person{"Test", 20}
	Super(ex)
	fmt.Println(ex.Age)
}

func Super(s *Person) {
	s.Age += 1
}
```

# Data Structures

#### Arrays
```
var scores [10]int
scores[0] = 339

scores := [4]int{9001, 9333, 212, 33}
for index, value := range scores { }
```

#### Slices

* Definition
```
// When elements are known in advance
scores := []int{1, 4, 293, 4, 9}

// When you’ll be writing into specific indexes of a slice
scores := make([]int, 10)

// Initialize a slice with a length of 0 and a capacity of 10
//	the length is the size of the slice
//	the capacity is the size of the underlying array
scores := make([]int, 0, 10)

// nil slice and is used in conjunction with append, when the number of elements is unknown
var names []string
```

* Usage
```
// Resize a slice
scores := make([]int, 0, 10)
scores = scores[0:8]
scores[7] = 9033

// Expand a slice
scores := make([]int, 1, 10)    // size 1
scores = append(scores, 5)      // size 2
fmt.Println(scores)             // prints [0, 5]

// Usage
func extractAgess(people []*Person) []int {
	ages := make([]int, 0, len(people))
	for _, person := range people {
		ages = append(ages, person.Age)
	}
	return ages
}

// Usage
scores := []int{1,2,3,4,5}
slice := scores[2:4]
slice[0] = 999
fmt.Println(scores)             // [1, 2, 999, 4, 5]

// SLICING DOESN'T CREATE A NEW ARRAY, IT MODIFIES THE EXISTING ONE
```

#### Maps
```
lookup := make(map[string]int)
lookup["test"] = 20
age, exists := lookup["test"]

total := len(lookup)
delete(lookup, "test")

// Map as a field of a structure
type Person struct {
	Name string
	Friends map[string]*Person
}
test := &Person{
	Name: "Test",
	Friends: make(map[string]*Person),
}

// Declare as a composite literal
lookup := map[string]int{
	"test": 21,
	"test2": 22,
}

// Iterate
for key, value := range lookup { ... }
```

#### Errors
```
import (
	"errors"
)

return errors.New("Invalid count")
```



# Objects

#### Functions on structures
```
type Person struct {
	Name string
	Age int
}

func (s *Person) Super() {        // *Person is the receiver of the Super method
	s.Age += 1
}

ex := &Person{"Test", 20}
ex.Super()
fmt.Println(ex.Age)              // will print 21
```

#### Constructors
```
func NewPerson(name string, age int) *Person {
	return &Person{
		Name: name,
		Age: age,
	}
}
```

#### Composition
```
type Worker struct {
	Name string
}

func (w *Worker) Introduce() {
	fmt.Printf("My name is: %s\n", w.Name)
}

type Person {
	*Worker
	Age int
}

// How to use it
ex := &Person{
	Worker: &Worker{"Test"},
	Age: 20,
}
ex.Introduce()
```

# Concurrency

#### Defer
```
file, err := os.Open("a_file_to_read")
if err != nil {
	fmt.Println(err)
	return
}
defer file.Close()
// read the file
```

#### Goroutines
```
package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("start")
	go process()
	time.Sleep(time.Millisecond * 10)
	fmt.Println("done")
}

func process() {
	fmt.Println("processing")
}
```

#### -Synchronization- (better to use Channels)
```
package main

import (
	"fmt"
	"time"
	"sync"
)

var (
	counter = 0
	lock sync.Mutex
)

func main() {
	for i := 0; i < 20; i++ {
		go incr()
	}
	time.Sleep(time.Millisecond * 10)
}

func incr() {
	lock.Lock()
	defer lock.Unlock()
	counter++
	fmt.Println(counter)
}
```

#### Channels
```
func main() {
	c := make(chan int, 100)      // buffer of 100
	for i := 0; i < 5; i++ {
		worker := &Worker{id: i}
		go worker.process(c)
	}
	for {
		select {
			case c <- rand.Int():
				//optional code here
			case <-time.After(time.Millisecond * 100):
				fmt.Println("timed out") }
			default:
				//this can be left empty to silently drop the data fmt.Println("dropped")
		}
		time.Sleep(time.Millisecond * 50)
	}
}

type Worker struct {
	id int
}

func (w *Worker) process(c chan int) {
	for {
		select {
			case data := <-c
				fmt.Printf("worker %d got %d\n", w.id, data)
			 case <-time.After(time.Millisecond * 10):
				fmt.Println("Break time")
				time.Sleep(time.Second)
	}
}
```