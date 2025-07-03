"
A matcherWildCard is like a jocker, whenever a MatcherWildCard is created, for the first matching process the isMatch is true, and the context is filled with the matcher value and alias. Then when a new match is applied, it will start matching the values with the existing context. So the idea is to match two Objects together to see if they exactly match and have the same properties. 
It is also used to indicate an unknown property, when one only cares for its value:
For example:

```
ClassA % {
	#_ <=> aValue.
}
```
"
Class {
	#name : 'MatcherWildcard',
	#superclass : 'Matcher',
	#instVars : [
		'alias'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherWildcard class >> of: aSymbol [
	^ self new alias: aSymbol ;
		yourself 
	
]

{ #category : 'accessors' }
MatcherWildcard >> alias [
	^ alias
]

{ #category : 'accessor' }
MatcherWildcard >> alias: aString [ 
	 alias := aString .
]

{ #category : 'accessors' }
MatcherWildcard >> isAnonymous [
	^ alias asSymbol = #_ 
]

{ #category : 'accessors' }
MatcherWildcard >> isWildcard [ 
	^ true
]

{ #category : 'private-running' }
MatcherWildcard >> match: aNewValue withContext: aMatchingContext [

	| aResult |
	self isAnonymous ifTrue: [ 
		aMatchingContext isMatch: true.
		^ { aMatchingContext } ].

	aResult := aMatchingContext bindings at: alias ifAbsentPut: [ 
		           aMatchingContext isMatch: true.
		           aNewValue ].
	aMatchingContext isMatch: aResult = aNewValue.

	^ { aMatchingContext }
]
