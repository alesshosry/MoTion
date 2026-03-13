Class {
	#name : 'MatcherUnorderedCollectionTest',
	#superclass : 'MatcherTests',
	#category : 'MoTion-Tests-matchers',
	#package : 'MoTion-Tests',
	#tag : 'matchers'
}

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testListWildcardAndWildcard [
	
	| pattern result | 
	pattern := { #'@anItem'. #'*aList'. } orderIgnored.
	result := pattern match: #( 1 2 3 ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testListWildcardAndWildcardAndLiteral [
	
	| pattern result | 
	pattern := { 3. #'@anItem'. #'*aList'} orderIgnored.
	result := pattern match: #( 1. 2. 3 ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testListWildcardEmpty [
	
	| pattern result | 
	pattern := { #'*listEmpty'} orderIgnored .
	result := pattern match: #( ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testListWildcardMultipleNotEmpty [
	
	| pattern result | 
	pattern := { #'*list1'. #'*list2'. } orderIgnored.
	result := pattern match: #( 1. 2. ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testListWildcardNotEmpty [
	
	| pattern result | 
	pattern := { #'*list'. } orderIgnored.
	result := pattern match: #( 1. 2. ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiterals [

	| pattern result |
	pattern := { 2. 1. 'a'} orderIgnored.
	result := pattern match: #( 1 2 'a').
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiteralsLess [
	
	| pattern result | 
	pattern := { 2.} orderIgnored.
	result := pattern match: #( 1 2 'a'). 
	self deny: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiteralsNumbers [

	| pattern result |
	pattern := { 2. 1. } orderIgnored.
	result := pattern match: #( 1 2 ).
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiteralsString [

	| pattern result |
	pattern := { 'Hello'. 'World' } orderIgnored.
	result := pattern match: #( 'World' 'Hello' ).
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiteralsWithObject [

	| pattern a1 result|
	
	pattern := MTTestObjectA % {
			             #lst <=> { 1. 2. } orderIgnored 
			 		}.

	a1 := MTTestObjectA new.
	a1 lst add: 1.
	a1 lst add: 2. 
	
	result := pattern match: a1.
	self assert: result isMatch.
	
	a1 lst add: 3.
	result := pattern match: a1.
	self deny: result isMatch.
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testWildcardSingle [
	
	| pattern result | 
	pattern := { #'@anItem'.} orderIgnored.
	result := pattern match: #( 1 ). 
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testWildcardSingle2 [
	
	| pattern result | 
	pattern := { #'@anItem'.} orderIgnored.
	result := pattern match: #( 1. 2 ). 
	self deny: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testWildcardsPattern [
	
	"not working yet, but should be"
	| pattern result | 
	pattern := { #'@item1'. #'@item2'.} orderIgnored.
	result := pattern match: #( 1 2 ). 
	self assert: result isMatch
]
