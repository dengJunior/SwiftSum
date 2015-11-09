//
//  StringsAndCharactersDemo.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/4.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

class StringsAndCharactersDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func stringsAndCharactersDemo() {
        // MARK: - 字符串和字符
        
        /**
        *  String类型是一种快速、现代化的字符串实现。 
        每一个字符串都是由编码无关的 Unicode 字符组成，并支持访问字符的多种 Unicode 表示形式（representations）。
        
        注意：
        Swift 的String类型与 Foundation NSString类进行了无缝桥接。
        如果您利用 Cocoa 或 Cocoa Touch 中的 Foundation 框架进行工作。
        所有NSString API 都可以调用您创建的任意String类型的值。除此之外，还可以使用本章介绍的String特性。
        */
        
        // MARK: - 字符串字面量（String Literals）
        /**
        *  字符串字面量可以包含以下特殊字符：
        
        转义字符\0(空字符)、\\(反斜线)、\t(水平制表符)、\n(换行符)、\r(回车符)、\"(双引号)、\'(单引号)。
        Unicode 标量，写成\u{n}(u为小写)，其中n为任意的一到八位十六进制数。
        */
        
        let wiseWords = "\"我是要成为海贼王的男人\" - 路飞"
        let dollarSign = "\u{24}"       // $,  Unicode 标量 U+0024
        let sparklingHeart = "\u{1F496}" // 💖, Unicode 标量 U+1F496
        
        // MARK: - 初始化空字符串 (Initializing an Empty String)
        var emptyString = ""
        var anotherEmptyString = String()
        
        //通过检查其Boolean类型的isEmpty属性来判断该字符串是否为空：
        if emptyString.isEmpty {
            print("Nothing to see here")
        }
        // 打印输出："Nothing to see here"
        
        // MARK: - 字符串是值类型（Strings Are Value Types）
        /**
        *  Swift 的String类型是值类型。
        如果您创建了一个新的字符串，那么当其进行常量、变量赋值操作或在函数/方法中传递时，会进行值拷贝。
        任何情况下，都会对已有字符串值创建新副本，并对该新副本进行传递或赋值操作。
        这样就类似int 这种变量了
        
        在实际编译时，Swift 编译器会优化字符串的使用，使实际的复制只发生在绝对必要的情况下，
        这意味着您将字符串作为值类型的同时可以获得极高的性能。
        */
        
        /**
        *  注意：
        与 Cocoa 中的NSString不同，当您在 Cocoa 中创建了一个NSString实例，并将其传递给一个函数/方法，或者赋值给一个变量，
        您传递或赋值的是该NSString实例的一个引用，除非您特别要求进行值拷贝，否则字符串不会生成新的副本来进行赋值操作。
        */
        
        
        // MARK: - 使用字符（Working with Characters）
        /**
        可通过for-in循环来遍历字符串中的characters属性来获取每一个字符的值：
        */
        for character in "Dog!🐶".characters {
            print(character)
        }
        // D
        // o
        // g
        // !
        // 🐶
        
        //通过标明一个Character类型并用字符字面量进行赋值，可以建立一个独立的字符常量或变量：
        let exclamatinMark: Character = "!"
        
        //字符串可以通过传递一个值类型为Character的数组作为自变量来初始化：
        let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
        let catString = String(catCharacters)
        print(catString)
        // 打印输出："Cat!🐱"
        
        
        // MARK: - 计算字符数量 (Counting Characters)
        let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
        //如果想要获得一个字符串中Character值的数量，可以使用字符串的characters属性的count属性：
        (unusualMenagerie).characters.count //40
        (unusualMenagerie.utf8).count//52
        unusualMenagerie.utf16.count//44
        /**
        注意： 可扩展的字符群集可以组成一个或者多个 Unicode 标量。
        不同的 Unicode 字符以及相同 Unicode 字符的不同表示方式可能需要不同数量的内存空间来存储。
        所以 Swift 中的字符在一个字符串中并不一定占用相同的内存空间数量。因此在没有获取字符串的可扩展的字符群的范围时候，就不能计算出字符串的字符数量。
        
        如果您正在处理一个长字符串，需要注意characters属性必须遍历全部的 Unicode 标量，来确定字符串的字符数量。
        
        另外需要注意的是通过characters属性返回的字符数量并不总是与包含相同字符的NSString的length属性相同。
        NSString的length属性是利用 UTF-16 表示的十六位代码单元数字，而不是 Unicode 可扩展的字符群集。
        
        作为佐证，当一个NSString的length属性被一个Swift的String值访问时，实际上是调用了utf16Count。
        */
        
        
        /**
        *  注意在 Swift 中，使用可拓展的字符群集作为Character值来连接或改变字符串时，并不一定会更改字符串的字符数量。
        */
        
        var word = "cafe"
        print("the number of characters in \(word) is \(word.characters.count)")
        // 打印输出 "the number of characters in cafe is 4"
        
        word += "\u{301}"    // COMBINING ACUTE ACCENT, U+0301
        
        print("the number of characters in \(word) is \(word.characters.count)")
        // 打印输出 "the number of characters in café is 4"
        
        
        // MARK: - 连接字符串和字符 (Concatenating Strings and Characters)
        
        let string2 = " there"
        var welcome = "hello" + string2
        
        welcome += " world"
        
        let exclamationMark: Character = "!"
        welcome.append(exclamationMark) //append方法将一个字符附加到一个字符串变量的尾部：
        
        
        
        // MARK: - 字符串插值 (String Interpolation)
        
        //字符串插值是一种构建新字符串的方式，可以在其中包含常量、变量、字面量和表达式。 
        let multiplier = 3
        let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
        // message is "3 times 2.5 is 7.5"

        // MARK: - Unicode
        /**
        *  Unicode 是一个国际标准，用于文本的编码和表示。 
        它使您可以用标准格式表示来自任意语言几乎所有的字符，并能够对文本文件或网页这样的外部资源中的字符进行读写操作。 
        Swift 的String和Character类型是完全兼容 Unicode 标准的。
        */
        
        /**
        *  Unicode 术语（Unicode Terminology
        
        Swift 的String类型是基于 Unicode 标量 建立的。 
        
        Unicode 中每一个字符都可以被解释为一个或多个 unicode 标量。
        字符的 unicode 标量是一个唯一的21位数字(和名称)，例如U+0061表示小写的拉丁字母A ("a")，U+1F425表示小鸡表情 ("🐥")
        
        当 Unicode 字符串被写进文本文件或其他存储结构当中，这些 unicode 标量将会按照 Unicode 定义的集中格式之一进行编码。
        其包括UTF-8（以8位代码单元进行编码） 和UTF-16（以16位代码单元进行编码）。
        
        
        字符串的 Unicode 表示（Unicode Representations of Strings）
        
        Swift 提供了几种不同的方式来访问字符串的 Unicode 表示。
        
        您可以利用for-in来对字符串进行遍历，从而以 Unicode 字符的方式访问每一个字符值。 该过程在 使用字符 中进行了描述。
        
        另外，能够以其他三种 Unicode 兼容的方式访问字符串的值：
        
        UTF-8 代码单元集合 (利用字符串的utf8属性进行访问)
        UTF-16 代码单元集合 (利用字符串的utf16属性进行访问)
        21位的 Unicode 标量值集合 (利用字符串的unicodeScalars属性进行访问)
        */
        
        
        
        // MARK: - 字符串字面量的特殊字符 (Special Characters in String Literals)
        
        /*
        字符串字面量可以包含以下特殊字符：
        
        转义字符\0(空字符)、\\(反斜线)、\t(水平制表符)、\n(换行符)、\r(回车符)、\"(双引号)、\'(单引号)。
        Unicode 标量，写成\u{n}(u为小写)，其中n为任意一到八位十六进制数且可用的 Unicode 位码。
        */
        
        let wiseWordsd = "\"Imagination is more important than knowledge\" - Einstein"
        // "Imageination is more important than knowledge" - Enistein
        let dollarSignd = "\u{24}"             // $, Unicode 标量 U+0024
        let blackHeartd = "\u{2665}"           // ♥, Unicode 标量 U+2665
        let sparklingHeartd = "\u{1F496}"      // 💖, Unicode 标量 U+1F496
        
        
        // MARK: - 字符串索引 (String Indices)
        
        /**
        *  每一个String值都有一个关联的索引(index)类型，String.Index，它对应着字符串中的每一个Character的位置。
        
        前面提到，不同的字符可能会占用不同数量的内存空间，所以要知道Character的确定位置，就必须从String开头遍历每一个 Unicode 标量直到结尾。
        因此，Swift 的字符串不能用整数(integer)做索引。
        
        
        使用startIndex属性可以获取一个String的第一个Character的索引。
        使用endIndex属性可以获取最后一个Character的后一个位置的索引。
        因此，endIndex属性不能作为一个字符串的有效下标。如果String是空串，startIndex和endIndex是相等的。
        */
        
        /**
        *  通过调用String.Index的predecessor()方法，可以立即得到前面一个索引，调用successor()方法可以立即得到后面一个索引。
        任何一个String的索引都可以通过锁链作用的这些方法来获取另一个索引，也可以调用advancedBy(_:)方法来获取。
        但如果尝试获取出界的字符串索引，就会抛出一个运行时错误。
        */
        
        let greeting = "Guten Tag!"
        greeting[greeting.startIndex]
        // G
        greeting[greeting.endIndex.predecessor()]
        // !
        greeting[greeting.startIndex.successor()]
        // u
        let index = greeting.startIndex.advancedBy(7)
        greeting[index]
        // a
        
        //试图获取越界索引对应的Character，将引发一个运行时错误。
        greeting[greeting.endIndex] // error
        greeting.endIndex.successor() // error
        
        
        //使用characters属性的indices属性会创建一个包含全部索引的范围(Range)，用来在一个字符串中访问单个字符。
        for index in greeting.characters.indices {
            print("\(greeting[index]) ", terminator: " ")
        }
        // 打印输出 "G u t e n   T a g !"
        
        // MARK: - 插入和删除 (Inserting and Removing)
        
        //调用insert(_:atIndex:)方法可以在一个字符串的指定索引插入一个字符。
        var welcome1 = "hello"
        welcome1.insert("!", atIndex: welcome.endIndex)
        // welcome now 现在等于 "hello!"
        
        welcome.insertContentsOf(" there".characters, at: welcome.endIndex.predecessor())
        // welcome 现在等于 "hello there!"
        
        welcome.removeAtIndex(welcome.endIndex.predecessor())
        
        let range = welcome.endIndex.advancedBy(-6)..<welcome.endIndex
        welcome.removeRange(range)
        
        
        // MARK: - 比较字符串 (Comparing Strings)
        
        //字符串/字符相等 (String and Character Equality)
        let quotation = "We're a lot alike, you and I."
        let sameQuotation = "We're a lot alike, you and I."
        if quotation == sameQuotation {
            print("These two strings are considered equal")
        }
        // 打印输出 "These two strings are considered equal"
        
        /**
        *  如果两个字符串（或者两个字符）的可扩展的字形群集是标准相等的，那就认为它们是相等的。
        在这个情况下，即使可扩展的字形群集是有不同的 Unicode 标量构成的，只要它们有同样的语言意义和外观，就认为它们标准相等。
        */
        
        // "Voulez-vous un café?" 使用 LATIN SMALL LETTER E WITH ACUTE
        let eAcuteQuestion = "Voulez-vous un caf\u{E9}?"
        
        // "Voulez-vous un café?" 使用 LATIN SMALL LETTER E and COMBINING ACUTE ACCENT
        let combinedEAcuteQuestion = "Voulez-vous un caf\u{65}\u{301}?"
        
        if eAcuteQuestion == combinedEAcuteQuestion {
            print("These two strings are considered equal")
        }
        // 打印输出 "These two strings are considered equal"
        
        //相反，英语中的LATIN CAPITAL LETTER A(U+0041，或者A)不等于俄语中的CYRILLIC CAPITAL LETTER A(U+0410，或者A)。两个字符看着是一样的，但却有不同的语言意义：
        
        let latinCapitalLetterA: Character = "\u{41}"
        
        let cyrillicCapitalLetterA: Character = "\u{0410}"
        
        if latinCapitalLetterA != cyrillicCapitalLetterA {
            print("These two characters are not equivalent")
        }
        // 打印 "These two characters are not equivalent"
        
        //注意： 在 Swift 中，字符串和字符并不区分区域。
        
        // MARK: - 前缀/后缀相等 (Prefix and Suffix Equality)
        
        /**
        *  通过调用字符串的hasPrefix(_:)/hasSuffix(_:)方法来检查字符串是否拥有特定前缀/后缀，两个方法均接收一个String类型的参数，并返回一个布尔值。
        */
        welcome.hasPrefix("hh")
        
        // MARK: - 字符串的 Unicode 表示形式（Unicode Representations of Strings）
        
        /**
        *  当一个 Unicode 字符串被写进文本文件或者其他储存时，字符串中的 Unicode 标量会用 Unicode 定义的几种编码格式编码。
        每一个字符串中的小块编码都被称为代码单元。
        这些包括 UTF-8 编码格式（编码字符串为8位的代码单元）， 
        UTF-16 编码格式（编码字符串位16位的代码单元），
        以及 UTF-32 编码格式（编码字符串32位的代码单元）。
        
        
        Swift 提供了几种不同的方式来访问字符串的 Unicode 表示形式。 
        您可以利用for-in来对字符串进行遍历，从而以 Unicode 可扩展的字符群集的方式访问每一个Character值。
        
        另外，能够以其他三种 Unicode 兼容的方式访问字符串的值：
        
        UTF-8 代码单元集合 (利用字符串的utf8属性进行访问)
        UTF-16 代码单元集合 (利用字符串的utf16属性进行访问)
        21位的 Unicode 标量值集合，也就是字符串的 UTF-32 编码格式 (利用字符串的unicodeScalars属性进行访问)
        */
        
        //下面由D``o``g``‼(DOUBLE EXCLAMATION MARK, Unicode 标量 U+203C)和�(DOG FACE，Unicode 标量为U+1F436)组成的字符串中的每一个字符代表着一种不同的表示：
        let dogString = "Dog‼🐶"
        
        // MARK: - UTF-8 表示
        
        for codeUnit in dogString.utf8 {
            print("\(codeUnit) ", terminator: "")
        }
        print("")
        // 68 111 103 226 128 188 240 159 144 182
        
        /**
        *  上面的例子中，前三个10进制codeUnit值 (68, 111, 103) 代表了字符D、o和 g，它们的 UTF-8 表示与 ASCII 表示相同。 
        接下来的三个10进制codeUnit值 (226, 128, 188) 是DOUBLE EXCLAMATION MARK的3字节 UTF-8 表示。 
        最后的四个codeUnit值 (240, 159, 144, 182) 是DOG FACE的4字节 UTF-8 表示。
        */
        
        // MARK: - UTF-16 表示
        
        for codeUnit in dogString.utf16 {
            print("\(codeUnit) ", terminator: "")
        }
        print("")
        // 68 111 103 8252 55357 56374
        
        /**
        *  同样，前三个codeUnit值 (68, 111, 103) 代表了字符D、o和g，它们的 UTF-16 代码单元和 UTF-8 完全相同（因为这些 Unicode 标量表示 ASCII 字符）。
        
        第四个codeUnit值 (8252) 是一个等于十六进制203C的的十进制值。这个代表了DOUBLE EXCLAMATION MARK字符的 Unicode 标量值U+203C。这个字符在 UTF-16 中可以用一个代码单元表示。
        
        第五和第六个codeUnit值 (55357和56374) 是DOG FACE字符的 UTF-16 表示。 第一个值为U+D83D(十进制值为55357)，第二个值为U+DC36(十进制值为56374)。
        */
        
        
        // MARK: - Unicode 标量表示 (Unicode Scalars Representation)
        
        /**
        *  您可以通过遍历String值的unicodeScalars属性来访问它的 Unicode 标量表示。 
        其为UnicodeScalarView类型的属性，UnicodeScalarView是UnicodeScalar的集合。
        UnicodeScalar是21位的 Unicode 代码点。
        
        每一个UnicodeScalar拥有一个value属性，可以返回对应的21位数值，用UInt32来表示：
        */
        
        for scalar in dogString.unicodeScalars {
            print("\(scalar.value) ", terminator: "")
        }
        print("")
        // 68 111 103 8252 128054
        
        /**
        *  前三个UnicodeScalar值(68, 111, 103)的value属性仍然代表字符D、o和g。 
        第四个codeUnit值(8252)仍然是一个等于十六进制203C的十进制值。这个代表了DOUBLE EXCLAMATION MARK字符的 Unicode 标量U+203C。
        
        第五个UnicodeScalar值的value属性，128054，是一个十六进制1F436的十进制表示。其等同于DOG FACE的 Unicode 标量U+1F436。
        */
        
        //作为查询它们的value属性的一种替代方法，每个UnicodeScalar值也可以用来构建一个新的String值，比如在字符串插值中使用：
        
        for scalar in dogString.unicodeScalars {
            print("\(scalar) ")
        }
        // D
        // o
        // g
        // ‼
        // 🐶
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
