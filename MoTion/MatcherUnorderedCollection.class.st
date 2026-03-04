Class {
	#name : 'MatcherUnorderedCollection',
	#superclass : 'Matcher',
	#instVars : [
		'matcherSequence'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherUnorderedCollection class >> of: aMatcherSequence [
	^ self new matcherSequence: aMatcherSequence; yourself
]

{ #category : 'matching' }
MatcherUnorderedCollection >> match: aCollection withContext: aMatchingContext [

	| patternChildren patternSize literals wildcards listWildCards results |
	results := OrderedCollection new.
	patternChildren := matcherSequence copy.
	patternSize := patternChildren size.

	"start looping over elements"
	"get all literal"
	literals := patternChildren select: [ :each |
		            each isKindOf: MatcherLiteral ].

	results := self match: aCollection withContext: aMatchingContext forLiterals: literals.

	"get all wildcard"
	wildcards := patternChildren select: [ :each |
		             each class = MatcherWildcard ].

	"get all list wildcard"
	listWildCards := patternChildren select: [ :each |
		                 each class = MatcherListWildcard ].

	"Objects"
	"to be done"

	"fill the matching contexts"
	^ results asArray
]

{ #category : 'matching' }
MatcherUnorderedCollection >> match: aCollection withContext: aMatchingContext forLiterals: literals [

	| results collectedLiteralsValues hasNext |
	
	results := OrderedCollection new.

	collectedLiteralsValues := literals collect: [ :each | each value ].
	hasNext := aCollection includesAll: collectedLiteralsValues.
	"not clean at all; but this is momentarely"
	hasNext ifTrue: [
		| aContext |
		aContext := aMatchingContext copy.
		aContext isMatch: true.
		results add: aContext ].

	^ results asArray
]

{ #category : 'accessing' }
MatcherUnorderedCollection >> matcherSequence [

	^ matcherSequence
]

{ #category : 'accessing' }
MatcherUnorderedCollection >> matcherSequence: anObject [

	matcherSequence := anObject
]
