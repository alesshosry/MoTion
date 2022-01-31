Class {
	#name : #MatcherWildcard,
	#superclass : #Matcher,
	#instVars : [
		'alias'
	],
	#category : #'MoTion-matcher'
}

{ #category : #'instance creation' }
MatcherWildcard class >> of: aSymbol [
	^ self new alias: aSymbol ;
		yourself 
	
]

{ #category : #accessors }
MatcherWildcard >> alias [
	^ alias
]

{ #category : #accessor }
MatcherWildcard >> alias: aString [ 
	 alias := aString .
]

{ #category : #'private-running' }
MatcherWildcard >> match: aNewValue withContext: aMatchingContext [

	| aResult |
	aResult := aMatchingContext bindings at: alias ifAbsentPut: [ 
		           aMatchingContext isMatch: true.
		           aNewValue ].
	aMatchingContext isMatch: aResult = aNewValue.

	^ { aMatchingContext }
]
