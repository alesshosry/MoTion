Class {
	#name : #Matcher,
	#superclass : #Object,
	#instVars : [
		'matchingContexts'
	],
	#category : #'MoTion-matcher'
}

{ #category : #initialization }
Matcher >> asMatcher [

	^ self
]

{ #category : #initialization }
Matcher >> initialize [ 
	super initialize.
	matchingContexts := OrderedCollection new.
]

{ #category : #accessing }
Matcher >> match: aNewValue [

	| aNewContext matcherResult |
	aNewContext := MatchingContext new.
	matcherResult := MatcherResult new.

	^ matcherResult addAllIfMatch:
		  (self match: aNewValue withContext: aNewContext)
]

{ #category : #accessing }
Matcher >> match: aNewValue withContext: aMatchingContext [
	
	self shouldBeImplemented 
	
]

{ #category : #accessing }
Matcher >> matchingContexts [

	^ matchingContexts
]
