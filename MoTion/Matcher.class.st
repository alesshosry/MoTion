Class {
	#name : #Matcher,
	#superclass : #Object,
	#instVars : [
		'value',
		'matchingContexts'
	],
	#category : #'MoTion-matcher'
}

{ #category : #initialization }
Matcher >> initialize [ 
	super initialize.
	matchingContexts := Collection new.
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

{ #category : #accessing }
Matcher >> value [

	^ value
]

{ #category : #accessing }
Matcher >> value: aValue [

	value := aValue 
]
