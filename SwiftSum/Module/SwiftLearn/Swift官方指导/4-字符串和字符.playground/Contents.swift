//: Playground - noun: a place where people can play

import UIKit

//String类型是一种快速、现代化的字符串实现。 每一个字符串都是由编码无关的 Unicode 字符组成，并支持访问字符的多种 Unicode 表示形式（representations）。

//Swift 的String类型与 Foundation NSString类进行了无缝桥接。

// MARK: - ## 字符串字面量（String Literals）

let someString = "Some string literal value"

// MARK: - ## 初始化空字符串 (Initializing an Empty String)

var emptyString = ""               // 空字符串字面量
var anotherEmptyString = String()  // 初始化方法
// 两个字符串均为空并等价。

//字符串可以通过传递一个值类型为Character的数组作为自变量来初始化：

let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString) // 打印输出："Cat!🐱"

// MARK: - ## 字符串可变性 (String Mutability)

//可以通过将一个特定字符串分配给一个变量来对其进行修改，或者分配给一个常量来保证其不会被修改：
var variableString = "Horse"
variableString += " and carriage"

// MARK: - ## 字符串是值类型（Strings Are Value Types）

//Swift 的String类型是值类型。 如果您创建了一个新的字符串，那么当其进行常量、变量赋值操作，或在函数/方法中传递时，会进行值拷贝。

//在实际编译时，Swift 编译器会优化字符串的使用，使实际的复制只发生在绝对必要的情况下，这意味着您将字符串作为值类型的同时可以获得极高的性能。

// MARK: - ## 使用字符（Working with Characters）

for character in "Dog!🐶".characters {
    print(character)
}
// D
// o
// g
// !
// 🐶

// MARK: - ## 连接字符串和字符 (Concatenating Strings and Characters)

//字符串可以通过加法运算符（+）相加在一起（或称“连接”）创建一个新的字符串：
//
//可以用append()方法将一个字符附加到一个字符串变量的尾部：

var welcome = "hello there"
let exclamationMark: Character = "!"
welcome.append(exclamationMark)// welcome 现在等于 "hello there!"

// MARK: - ## 字符串插值 (String Interpolation)

//字符串插值是一种构建新字符串的方式，可以在其中包含常量、变量、字面量和表达式。

let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message is "3 times 2.5 is 7.5"

// MARK: - ## Unicode
//Unicode 是一个国际标准，用于文本的编码和表示。Swift 的String和Character类型是完全兼容 Unicode 标准的。

// MARK: - ### Unicode 标量（Unicode Scalars）

//Swift 的String类型是基于 Unicode 标量 建立的。 Unicode 标量是对应字符或者修饰符的唯一的21位数字，例如U+0061表示小写的拉丁字母(LATIN SMALL LETTER A)("a")，U+1F425表示小鸡表情(FRONT-FACING BABY CHICK) ("🐥")。

//>注意： Unicode 码位(code poing) 的范围是U+0000到U+D7FF或者U+E000到U+10FFFF。Unicode 标量不包括 Unicode 代理项(surrogate pair) 码位，其码位范围是U+D800到U+DFFF。
//注意不是所有的21位 Unicode 标量都代表一个字符，因为有一些标量是留作未来分配的。已经代表一个典型字符的标量都有自己的名字，例如上面例子中的LATIN SMALL LETTER A和FRONT-FACING BABY CHICK。

// MARK: - ## 字符串字面量的特殊字符 (Special Characters in String Literals)

//字符串字面量可以包含以下特殊字符：

//转义字符\0(空字符)、\\(反斜线)、\t(水平制表符)、\n(换行符)、\r(回车符)、\"(双引号)、\'(单引号)。

//Unicode 标量，写成\u{n}(u为小写)，其中n为任意一到八位十六进制数且可用的 Unicode 位码。

let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
let dollarSign = "\u{24}"             // $, Unicode 标量 U+0024
let blackHeart = "\u{2665}"           // ♥, Unicode 标量 U+2665
let sparklingHeart = "\u{1F496}"      // 💖, Unicode 标量 U+1F496

// MARK: - ## 可扩展的字形群集(Extended Grapheme Clusters)

//每一个 Swift 的Character类型代表一个可扩展的字形群。 一个可扩展的字形群是一个或多个可生成人类可读的字符 Unicode 标量的有序排列。

//举个例子，字母é可以用单一的 Unicode 标量é(LATIN SMALL LETTER E WITH ACUTE, 或者U+00E9)来表示。

let eAcute: Character = "\u{E9}"                         // é
let combinedEAcute: Character = "\u{65}\u{301}"          // e 后面加上  ́
// eAcute 是 é, combinedEAcute 是 é

// MARK: - ## 计算字符数量 (Counting Characters)
//使用字符串的characters属性的count属性：

let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
print(" has \(unusualMenagerie.characters.count) characters")
// 打印输出 "unusualMenagerie has 40 characters"

//注意在 Swift 中，使用可拓展的字符群集作为Character值来连接或改变字符串时，并不一定会更改字符串的字符数量。
var word = "cafe"
print(word.characters.count)//4

var word2 = "\u{301}"
print(word2.characters.count)//1

word += word2
print("word = \(word) count = \(word.characters.count)")//word = café count = 4

//注意： 可扩展的字符群集可以组成一个或者多个 Unicode 标量。这意味着不同的字符以及相同字符的不同表示方式可能需要不同数量的内存空间来存储。所以 Swift 中的字符在一个字符串中并不一定占用相同的内存空间数量。因此在没有获取字符串的可扩展的字符群的范围时候，就不能计算出字符串的字符数量。如果您正在处理一个长字符串，需要注意characters属性必须遍历全部的 Unicode 标量，来确定字符串的字符数量。

//另外需要注意的是通过characters属性返回的字符数量并不总是与包含相同字符的NSString的length属性相同。NSString的length属性是利用 UTF-16 表示的十六位代码单元数字，而不是 Unicode 可扩展的字符群集。

//当一个NSString的length属性被一个Swift的String值访问时，实际上是调用了utf16Count。

// MARK: - 字符串索引 (String Indices)

//每一个String值都有一个关联的索引(index)类型，String.Index，它对应着字符串中的每一个Character的位置。

//前面提到，不同的字符可能会占用不同数量的内存空间，所以要知道Character的确定位置，就必须从String开头遍历每一个 Unicode 标量直到结尾。因此，Swift 的字符串不能用整数(integer)做索引。

//使用startIndex属性可以获取一个String的第一个Character的索引。使用endIndex属性可以获取最后一个Character的后一个位置的索引。因此，endIndex属性不能作为一个字符串的有效下标。如果String是空串，startIndex和endIndex是相等的。

//通过调用String.Index的predecessor()方法，可以立即得到前面一个索引，调用successor()方法可以立即得到后面一个索引。

//任何一个String的索引都可以通过锁链作用的这些方法来获取另一个索引，也可以调用advancedBy(_:)方法来获取。但如果尝试获取出界的字符串索引，就会抛出一个运行时错误。

//你可以使用下标语法来访问String特定索引的Character。试图获取越界索引对应的Character，将引发一个运行时错误。

let greeting = "guten"
greeting[greeting.startIndex]//g
greeting[greeting.startIndex.successor()]//u
greeting[greeting.endIndex.predecessor()]//n

//使用characters属性的indices属性会创建一个包含全部索引的范围(Range)，用来在一个字符串中访问单个字符。
for index in greeting.characters.indices {
    print("\(greeting[index]) ", terminator: "")
}
// 打印输出 "G u t e n   T a g ! "

// MARK: - ## 插入和删除 (Inserting and Removing)
var welcome2 = "hello"
welcome2.insert("!", atIndex: welcome2.endIndex)
welcome2.insertContentsOf(" there".characters, at: welcome2.endIndex.predecessor())

welcome2.removeAtIndex(welcome2.endIndex.predecessor())
// welcome 现在等于 "hello there"

let range = welcome2.endIndex.advancedBy(-6)..<welcome2.endIndex
welcome2.removeRange(range)

// MARK: - ## 字符串/字符相等 (String and Character Equality)

// "Voulez-vous un café?" 使用 LATIN SMALL LETTER E WITH ACUTE
let eAcuteQuestion = "Voulez-vous un caf\u{E9}?"

// "Voulez-vous un café?" 使用 LATIN SMALL LETTER E and COMBINING ACUTE ACCENT
let combinedEAcuteQuestion = "Voulez-vous un caf\u{65}\u{301}?"

//如果两个字符串（或者两个字符）的可扩展的字形群集是标准相等的，那就认为它们是相等的。
if eAcuteQuestion == combinedEAcuteQuestion {
    print("These two strings are considered equal")
}


let latinCapitalLetterA: Character = "\u{41}" //A
let cyrillicCapitalLetterA: Character = "\u{0410}" //A

//相反，英语中的LATIN CAPITAL LETTER A(U+0041，或者A)不等于俄语中的CYRILLIC CAPITAL LETTER A(U+0410，或者A)。两个字符看着是一样的，但却有不同的语言意义
if latinCapitalLetterA != cyrillicCapitalLetterA {
    print("These two characters are not equivalent")
}

// MARK: - ## 前缀/后缀相等 (Prefix and Suffix Equality)

//>注意： hasPrefix(_:)和hasSuffix(_:)方法都是在每个字符串中逐字符比较其可扩展的字符群集是否标准相等，详细描述在字符串/字符相等。

// MARK: - ## 字符串的 Unicode 表示形式（Unicode Representations of Strings）

/*
 当一个 Unicode 字符串被写进文本文件或者其他储存时，字符串中的 Unicode 标量会用 Unicode 定义的几种编码格式（encoding forms）编码。
 
 每一个字符串中的小块编码都被称代码单元（code units）。这些包括 UTF-8 编码格式（编码字符串为8位的代码单元）， UTF-16 编码格式（编码字符串位16位的代码单元），以及 UTF-32 编码格式（编码字符串32位的代码单元）。
 
 Swift 提供了几种不同的方式来访问字符串的 Unicode 表示形式:
 
 - UTF-8 代码单元集合 (利用字符串的utf8属性进行访问)
 - UTF-16 代码单元集合 (利用字符串的utf16属性进行访问)
 - 21位的 Unicode 标量值集合，也就是字符串的 UTF-32 编码格式 (利用字符串的unicodeScalars属性进行访问)
 */
let dogString = "Dog‼🐶"

for codeUtf8 in dogString.utf8 {
    print(codeUtf8)
//    print(codeUtf8, terminator: " ")
    // 68 111 103 226 128 188 240 159 144 182
}
print("")
for codeUtf8 in dogString.utf16 {
    print(codeUtf8, terminator: " ")
    // 68 111 103 8252 55357 56374
}
print("")
//可以通过遍历String值的unicodeScalars属性来访问它的 Unicode 标量表示。 其为UnicodeScalarView类型的属性，UnicodeScalarView是UnicodeScalar类型的值的集合。 UnicodeScalar是21位的 Unicode 代码点。
for scalar in dogString.unicodeScalars {
    print(scalar, terminator: " ")
    // 68 111 103 8252 128054
    // D o g ‼ 🐶
}










