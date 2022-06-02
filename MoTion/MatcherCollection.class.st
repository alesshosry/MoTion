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

	| subjectCursor patternCursor subjectSize patternSize lvStarts lvLenghts lvMinLengths lvMaxLengths delta numberOfNonListWildcard reducedPatternSize reducedSubjectSize hasNext forward contexts |
	
	hasNext := true.
	forward := true.
	
	subjectSize := aCollection size.
	patternSize := matcherSequence size.
	lvStarts := Array new: patternSize.
	lvLenghts := Array new: patternSize.
	lvMinLengths := Array new: patternSize.
	lvMaxLengths := Array new: patternSize.
	
	reducedPatternSize := patternSize.
	reducedSubjectSize := subjectSize.
	
	subjectCursor := 1.
	patternCursor := 1.
	
	delta := 1.
	
	numberOfNonListWildcard := patternSize - self listWildcardPositions size.
	
	1 to: patternSize do: [ :i  | 
		(matcherSequence at: i)	isListWildcard ifTrue: [  
			lvMinLengths at: i put: 0.
			lvMaxLengths at: i put: (subjectSize - numberOfNonListWildcard).
			lvStarts at: i put: 1.
			lvLenghts at: i put: 0.
		].	
	].
	contexts := { aMatchingContext copy }.
	[ hasNext ] whileTrue: [ | pattern |
			pattern := matcherSequence at: patternCursor.
			pattern isListWildcard ifFalse: [ | newContexts |
				newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: subjectCursor) withContext: c ].
				(newContexts anySatisfy: #isMatch) ifTrue: [ contexts := newContexts. 
																		  patternCursor := patternCursor + 1.
																		  subjectCursor := subjectCursor + 1.] 
															 ifFalse: [ patternCursor := patternCursor - 1 ].			
			]
			ifTrue: [ | start min max length subjects |
				patternSize = patternCursor ifTrue: [ lvLenghts at: patternCursor put: (subjectSize - subjectCursor) ]
													ifFalse: [ lvLenghts at: patternCursor put: (lvLenghts at: patternCursor) + 1 ].
				
				length := lvLenghts at: patternCursor.
				start := lvStarts at: patternCursor.
				min := lvMinLengths at: patternCursor.
				max := lvMaxLengths at: patternCursor.
				subjects := aCollection copyFrom: start to: length.
				contexts := contexts flatCollect: [ :c | pattern match: subjects withContext: c ].
				
				lvStarts at: patternCursor put: (start + 1).
				self halt.
				patternCursor := patternCursor + 1.
				subjectCursor := start + length .
			].
		
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
