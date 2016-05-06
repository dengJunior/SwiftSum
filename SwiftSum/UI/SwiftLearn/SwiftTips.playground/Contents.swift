//: Playground - noun: a place where people can play

import UIKit

// MARK: - 10个惊艳的Swift单行代码

let array = (1...10)
//1 数组中的每个元素乘以2
let tip1 = (1...10).map { $0 * 2 }
print(tip1)

//2 数组中的元素求和
let tip2 = array.reduce(0, combine: +)

//3 验证在字符串中是否存在指定单词
let words = ["Swift","iOS","cocoa","OSX","tvOS"]
let tweet = "This is an example tweet larking about Swift"

//使用 filter来验证tweet中是否包含选定的若干关键字中的一个：
var valid = !words.filter{ tweet.containsString($0) }.isEmpty
valid//true

//方式更简洁
valid = words.contains(tweet.containsString)
valid//true

valid = tweet.characters.split(" ")
    .lazy
    .map(String.init)
    .contains(Set(words).contains)
valid

//4 读取文件
let path = NSBundle.mainBundle().pathForResource("test", ofType: "txt")
//let lines = try? String(contentsOfFile: path!).characters.split{$0 == "\n"}.map(String.init)
//if let lines=lines {
//    lines[0] // O! for a Muse of fire, that would ascend
//    lines[1] // The brightest heaven of invention!
//    lines[2] // A kingdom for a stage, princes to act
//    lines[3] // And monarchs to behold the swelling scene.
//}

//5 祝你生日快乐！

//这将显示生日快乐歌到控制台，通过map以及范围和三元运算符的简单使用。

let name = "uraimo"
(1...4).forEach{print("Happy Birthday " + (($0 == 3) ? "dear \(name)":"to You"))}


//6 过滤数组中的数字

//构建了包含两个分区的结果元组，一次一个元素，使用过滤函数测试初始序列中的每个元素，并根据过滤结果追加该元素到第一或第二分区数组中。
var part3 = [82, 58, 76, 49, 88, 90].reduce( ([],[]), combine: {
    (a:([Int],[Int]),n:Int) -> ([Int],[Int]) in
    (n<60) ? (a.0+[n],a.1) : (a.0,a.1+[n])
})
part3 // ([58, 49], [82, 76, 88, 90])


//7 获取并解析XML Web服务

//上面的有些语言不依赖外部库，并默认提供多个选项来处理XML（例如Scala虽然笨拙但“本地”地支持XML解析成对象），但Foundation只提供了SAX解析器NSXMLParser，并且正如你可能已经猜到的那样，我们不打算使用它。
//
//有几个替代的开源库，我们可以在这种情况下使用，其中一些用C或Objective-C编写，其他为纯Swift。
//
//这次，我们打算使用纯Swift的AEXML：

//let xmlDoc = try? AEXMLDocument(xmlData: NSData(contentsOfURL: NSURL(string:"https://www.ibiblio.org/xml/examples/shakespeare/hen_v.xml")!)!)
//if let xmlDoc=xmlDoc {
//    var prologue = xmlDoc.root.children[6]["PROLOGUE"]["SPEECH"]
//    prologue.children[1].stringValue // Now all the youth of England are on fire,
//    prologue.children[2].stringValue // And silken dalliance in the wardrobe lies:
//    prologue.children[3].stringValue // Now thrive the armourers, and honour's thought
//    prologue.children[4].stringValue // Reigns solely in the breast of every man:
//    prologue.children[5].stringValue // They sell the pasture now to buy the horse,
//}

//8 在数组中查找最小（或最大）值

//Find the minimum of an array of Ints
[10,-22,753,55,137,-1,-279,1034,77].sort().first
[10,-22,753,55,137,-1,-279,1034,77].reduce(Int.max, combine: min)
[10,-22,753,55,137,-1,-279,1034,77].minElement()
//Find the maximum of an array of Ints
[10,-22,753,55,137,-1,-279,1034,77].sort().last
[10,-22,753,55,137,-1,-279,1034,77].reduce(Int.min, combine: max)
[10,-22,753,55,137,-1,-279,1034,77].maxElement()


//9 并行处理

//某些语言允许用一种简单和透明的方式启用数组对功能，例如map和flatMap的并行处理，以加快顺序和独立操作的执行。
//
//此功能Swift中还不可用，但可以使用GCD构建：http://moreindirection.blogspot.it/2015/07/gcd-and-parallel-collections-in-swift.html

//10 埃拉托斯特尼筛法

//埃拉托斯特尼筛法用于查找所有的素数直到给定的上限n。
//
//从小于n的所有整数序列开始，算法删除所有整数的倍数，直到只剩下素数。并且为了加快执行速度，我们实际上并不需要检查每个整数的倍数，我们止步于n的平方根就可以了。

//使用flatMap的一个很好的例子以生成扁平化的嵌套数组。
let n = 9
var sameprimes = Set(2...n)
sameprimes.subtractInPlace((2...Int(sqrt(Double(n))))
    .flatMap{ (2*$0).stride(through:n, by:$0)})
sameprimes.sort()
sameprimes

//11 其他：通过解构元组交换
var a = 1, b = 2
(a,b) = (b,a)
a //2
b //1














