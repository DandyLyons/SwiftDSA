import SwiftDSA
import Testing

@Suite struct TrieTests {
    
    @Test func _init() {
        let trie = Trie()
        #expect(trie.count == 0)
    }
    
    @Test func insert() {
        var trie = Trie()
        trie.insert(word: "cute")
        trie.insert(word: "cutie")
        trie.insert(word: "fred")
        #expect(trie.contains(word: "cute") == true)
        #expect(trie.contains(word: "cut") == false)
        trie.insert(word: "cut")
        #expect(trie.contains(word: "cut") == true)
        #expect(trie.count == 4)
    }
    
    /// Tests the remove method
    @Test func remove() {
        var trie = Trie()
        trie.insert(word: "cute")
        trie.insert(word: "cut")
        #expect(trie.count == 2)
        trie.remove(word: "cute")
        #expect(trie.contains(word: "cut") == true)
        #expect(trie.contains(word: "cute") == false)
        #expect(trie.count == 1)
    }
    
    /// Tests the words property
    @Test func words() {
        var trie = Trie()
        var words = trie.words
        #expect(words.count == 0)
        trie.insert(word: "foobar")
        words = trie.words
        #expect(words[0] == "foobar")
        #expect(words.count == 1)
    }
    
    /// Tests whether word prefixes are properly found and returned.
    @Test func findWordsWithPrefix() {
        var trie = Trie()
        trie.insert(word: "test")
        trie.insert(word: "another")
        trie.insert(word: "exam")
        let wordsAll = trie.findWordsWithPrefix(prefix: "")
        #expect(wordsAll.sorted() == ["another", "exam", "test"])
        let words = trie.findWordsWithPrefix(prefix: "ex")
        #expect(words == ["exam"])
        trie.insert(word: "examination")
        let words2 = trie.findWordsWithPrefix(prefix: "exam")
        #expect(words2 == ["exam", "examination"])
        let noWords = trie.findWordsWithPrefix(prefix: "tee")
        #expect(noWords == [])
        let unicodeWord = "😬😎"
        trie.insert(word: unicodeWord)
        let wordsUnicode = trie.findWordsWithPrefix(prefix: "😬")
        #expect(wordsUnicode == [unicodeWord])
        trie.insert(word: "Team")
        let wordsUpperCase = trie.findWordsWithPrefix(prefix: "Te")
        #expect(wordsUpperCase.sorted() == ["team", "test"])
    }
    
    /// Tests whether word prefixes are properly detected on a boolean contains() check.
    @Test func testContainsWordMatchPrefix() {
        var trie = Trie()
        trie.insert(word: "test")
        trie.insert(word: "another")
        trie.insert(word: "exam")
        let wordsAll = trie.contains(word: "", matchPrefix: true)
        withKnownIssue {
            #expect(wordsAll == true)
        }
        let words = trie.contains(word: "ex", matchPrefix: true)
        #expect(words == true)
        trie.insert(word: "examination")
        let words2 = trie.contains(word: "exam", matchPrefix: true)
        #expect(words2 == true)
        let noWords = trie.contains(word: "tee", matchPrefix: true)
        #expect(noWords == false)
        let unicodeWord = "😬😎"
        trie.insert(word: unicodeWord)
        let wordsUnicode = trie.contains(word: "😬", matchPrefix: true)
        #expect(wordsUnicode == true)
        trie.insert(word: "Team")
        let wordsUpperCase = trie.contains(word: "Te", matchPrefix: true)
        #expect(wordsUpperCase == true)
    }
}
