Class {
	#name : #MatcherCollection,
	#superclass : #Matcher,
	#instVars : [
		'matcherSequence'
	],
	#category : #'MoTion-matcher'
}

{ #category : #'instance creation' }
MatcherCollection class >> of: aMatcherSequence [
	^ self new matcherSequence: aMatcherSequence; yourself
]

{ #category : #matching }
MatcherCollection >> hasListWildcards [

	^ self listWildcardPositions isNotEmpty
]

{ #category : #matching }
MatcherCollection >> initializeCursor: aMotionCursor withCollection: aCollection [

	aMotionCursor subjectSize: aCollection size.
	aMotionCursor patternSize: matcherSequence size.
	aMotionCursor lvStarts: (Array new: aMotionCursor patternSize). 
	aMotionCursor lvLengths: (Array new: aMotionCursor patternSize).
	aMotionCursor lvMinLengths: (Array new: aMotionCursor patternSize).
	aMotionCursor lvMaxLengths: (Array new: aMotionCursor patternSize).
	aMotionCursor subjectCursor: 1.
	aMotionCursor patternCursor: 1.
	aMotionCursor numberOfNonListWildcards: aMotionCursor patternSize - self listWildcardPositions size.
]

{ #category : #matching }
MatcherCollection >> isCollectionMatcher [
	^ true
]

{ #category : #matching }
MatcherCollection >> listWildcardPositions [

	| positions |
	positions := OrderedCollection new.
	matcherSequence doWithIndex: [ :e :i | 
		e isListWildcard ifTrue: [ positions add: i ] ].
	^ positions
]

{ #category : #matching }
MatcherCollection >> match2: aCollection withContext: aMatchingContext [

	| result |
	self flag: 'lazy algo, need to work with an automata instead'.
	aCollection size = matcherSequence size ifFalse: [ 
		aMatchingContext isMatch: false.
		^ { aMatchingContext } ].
	result := (matcherSequence collectWithIndex: [ :matcher :index | 
		           | object |
		           object := aCollection at: index.
		           matcher match: object withContext: aMatchingContext  ])
		          flattened select: [ :context | context isMatch ].
	result ifEmpty: [ aMatchingContext isMatch: false ].
	^ { aMatchingContext }
]

{ #category : #matching }
MatcherCollection >> match: aCollection withContext: aMatchingContext [

	|  motionCursor result|
	 
	motionCursor := MotionCursor new. 
	self initializeCursor: motionCursor withCollection: aCollection.
	self setCursorLengths: motionCursor.
	 
	[ motionCursor hasNext ] whileTrue: [  	
		"Here we can add a condition on result; When it is filled with contexts, this means that a combination was found, and we need to enter back the matchNext to look for another combination."
		
		"To be continued .... "
		result := self matchNext: aCollection withCursor:motionCursor withContext: aMatchingContext.  
	].

	^ {  }
	
]

{ #category : #matching }
MatcherCollection >> matchbak: aCollection withContext: aMatchingContext [

	| result patternIndex subjectIndex subjectLenght patternLength |
	
	subjectIndex := subjectIndex := 1.
	
	
	result := (matcherSequence collectWithIndex: [ :matcher :index | 
		           | object |
		           object := aCollection at: index.
		           matcher match: object withContext: aMatchingContext  ])
		          flattened select: [ :context | context isMatch ].
	result ifEmpty: [ aMatchingContext isMatch: false ].
	^ { aMatchingContext }
]

{ #category : #matching }
MatcherCollection >> matcherSequence: aSequence [

	matcherSequence := aSequence
]

{ #category : #initialization }
MatcherCollection >> setCursorLengths: aMotionCursor [
 
	1 to: aMotionCursor patternSize do: [ :i  | 
		(matcherSequence at: i)	isListWildcard ifTrue: [  
			aMotionCursor lvMinLengths at: i put: 0.
			aMotionCursor lvMaxLengths at: i put: (aMotionCursor subjectSize - aMotionCursor numberOfNonListWildcards).
			aMotionCursor lvStarts at: i put: 1.
			aMotionCursor lvLengths at: i put: 0.
		].	
	].
]
