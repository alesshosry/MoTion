Class {
	#name : #Matcher,
	#superclass : #Object,
	#instVars : [
		'matchingContexts'
	],
	#category : #'MoTion-matcher'
}

{ #category : #converting }
Matcher >> asMatcher [

	^ self
]

{ #category : #initialization }
Matcher >> initialize [ 
	super initialize.
	matchingContexts := OrderedCollection new.
]

{ #category : #matching }
Matcher >> match: aNewValue [

	| aNewContext matcherResult |
	aNewContext := MatchingContext new.
	matcherResult := MatcherResult new.

	^ matcherResult addAllIfMatch:
		  (self match: aNewValue withContext: aNewContext)
]

{ #category : #matching }
Matcher >> match: aNewValue withContext: aMatchingContext [
	
	self shouldBeImplemented 
	
]

{ #category : #matching }
Matcher >> matchingContexts [

	^ matchingContexts
]
