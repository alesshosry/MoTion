Class {
	#name : 'MatcherUnorderedCollectionTest',
	#superclass : 'MatcherTests',
	#category : 'MoTion-Tests-matchers',
	#package : 'MoTion-Tests',
	#tag : 'matchers'
}

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiteralsLessInPatterninUC [
	
	"This test is not working yet; I need to add support for wildcards, listWildCards ..."
	
	"| pattern result | 
	pattern := { 2.} orderIgnored.
	result := pattern match: #( 1 2 'a'). 
	self deny: result isMatch"
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiteralsNumbersinUC [

	| pattern result |
	pattern := { 2. 1. } orderIgnored.
	result := pattern match: #( 1 2 ).
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiteralsStringinUC [

	| pattern result |
	pattern := { 'Hello'. 'World' } orderIgnored.
	result := pattern match: #( 'World' 'Hello' ).
	self assert: result isMatch
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiteralsWithObjectInUC [

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
	self assert: result isMatch.
]

{ #category : 'tests' }
MatcherUnorderedCollectionTest >> testLiteralsinUC [

	| pattern result |
	pattern := { 2. 1. 'a'} orderIgnored.
	result := pattern match: #( 1 2 'a').
	self assert: result isMatch
]
