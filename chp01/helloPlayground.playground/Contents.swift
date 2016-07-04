//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, world"

print(str)


var a = [1, 2, 3]
var b = a
b.append(4)

let notes = [5, 10, 15, 20, 50, 40, 30]
//notes.map{"$\($0)"}
notes.map{note in
    return "$\(note)"
}

var x = notes.map{ "$\($0)"}
x

var y = notes.filter{$0 < 30}
y

var z = notes.reduce(0){
    $0 + $1
}

for i in (1..<5) {
    i
}

