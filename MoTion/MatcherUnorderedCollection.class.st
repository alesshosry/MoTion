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

{ #category : 'converting' }
MatcherUnorderedCollection >> isCollectionMatcher [
	^ true
]

{ #category : 'matching' }
MatcherUnorderedCollection >> match: aCollection withContext: aMatchingContext [ 
	
	"The concept of this algo is to give all possible iterations of the subjects and try to match each time using list matcher which takes order into consideration."
	
	"pay attention; case when collection is empty is not handled yet !"
	
	"this is a very basic method; dangereous when having lage models and with many childrens. logic to be changed: will implement it in match:WithContext2:"
	
	| results patternChildren subjectIterations|

	results := OrderedCollection new.	
	subjectIterations := 	OrderedCollection new.	
	patternChildren := MatcherCollection new. 
	patternChildren matcherSequence: matcherSequence copy.
	
	"get all subjects iterations possible"
	aCollection permutationsDo: [ :each | 
		subjectIterations add:each copy.
	].
	 
	subjectIterations do: [ :each | 
		results add: (patternChildren match: each withContext: aMatchingContext).
		]. 
	
	
 	^ results flattened asArray 
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
