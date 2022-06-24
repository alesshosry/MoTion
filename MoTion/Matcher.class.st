Class {
	#name : #Matcher,
	#superclass : #Object,
	#instVars : [
		'matchingContexts'
	],
	#category : #'MoTion-matcher'
}

{ #category : #initialization }
Matcher >> as: aSymbol [

	^ MatcherSave of: self withAlias: aSymbol
]

{ #category : #converting }
Matcher >> asMatcher [

	"creates instance of Matcher"

	^ self
]

{ #category : #accessing }
Matcher >> collectBinding: aString for: anObject [ 
	
	^ (self match: anObject) bindingsFor: aString
]

{ #category : #accessing }
Matcher >> collectBindings: bindings for: anObject [

	^ ((self match: anObject) matchingContexts collect: [ :context | 
		   context bindings filterKeys: bindings ]) removeDuplicates
]

{ #category : #matching }
Matcher >> debugMe [
	^ MatcherDebug of: self
]

{ #category : #initialization }
Matcher >> initialize [ 
	super initialize.
	matchingContexts := OrderedCollection new.
]

{ #category : #matching }
Matcher >> isBlockMatcher [

	^ false
]

{ #category : #converting }
Matcher >> isCollectionMatcher [ 
	^ false
]

{ #category : #converting }
Matcher >> isListWildcard [
	^ false
]

{ #category : #matching }
Matcher >> isMooseMatcher [

	^ false
]

{ #category : #converting }
Matcher >> isWildcard [
	^ false
]

{ #category : #matching }
Matcher >> match: aNewValue [

	"It is used to match aNewValue, but it is returning a list of emptyContext as there is no context defined here. The most important thing is to generalise the return of all match and match:withContext: of all the matchers in our code to return a list of MatchingContexts."
	
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

	"returns the list of matchingContexts only."
	^ matchingContexts
]

{ #category : #initialization }
Matcher >> orMatches: aMatcher [
	^ OrMatcher between: self and: aMatcher 
]
