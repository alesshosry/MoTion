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
MatcherCollection >> matchNext: aCollection withCursor: aMotionCursor withContext: aMatchingContext [
| pattern contexts |

contexts := { aMatchingContext copy }.

	"checking state of forward and cursors"
			"1- If forward and cursors reach the maximum then a match is detected: new binding (subjects combination) should be added to bindings in MatchingContext"
			
			aMotionCursor forward ifTrue: [
				(aMotionCursor patternCursor > aMotionCursor patternSize) ifTrue: [ 
					(aMotionCursor subjectCursor > aMotionCursor subjectSize) ifTrue: [ 
							" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
							"match is true: here we have to add the combination list to bindings" 
							" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
							 
							^ { }.
						].
					"here we have to go forward and decrement patternCursor"
					aMotionCursor forward: false.
					aMotionCursor patternCursor: aMotionCursor patternCursor - 1.
					].
				]
			ifFalse:[
				(aMotionCursor patternCursor >= aMotionCursor patternSize) ifTrue: [ 
					"decrement both when going back and patternCursor reached the patternSize"
					aMotionCursor patternCursor: aMotionCursor patternCursor - 1.
					aMotionCursor subjectCursor: aMotionCursor subjectCursor - 1.
				]					
			]. 
		
			"2- If one of the cursors is negative --> this means that no more combinations are available anymore. hasNext will be set to false and the  looping finishes"
			
			(aMotionCursor patternCursor < 0 or: (aMotionCursor subjectCursor <0)) ifTrue: [ 
				aMotionCursor hasNext: false.
			
			].
		
			"Get pattern and start checking its type: literal or listWildcard"
			pattern := matcherSequence at: aMotionCursor patternCursor.
			pattern isListWildcard ifFalse: [ 
				
				| newContexts |

				"1- Check if going forward & patternCursor didn't reach full size"
				(aMotionCursor forward and: [(aMotionCursor subjectCursor < aMotionCursor subjectSize)] ) ifTrue: [
					newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ].
					"2- Try to match by gettiong values based on patternCursor and subjectCursor"
					
					(newContexts anySatisfy: #isMatch) ifTrue: [ 
																				"3- Increment when there is a match"
																				contexts := newContexts. 
																		  		aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
																		  		aMotionCursor subjectCursor: aMotionCursor subjectCursor + 1.																				
																				] 
															 		ifFalse: [ 
																			"4- decrement patternCurso if no match and set forward to false to force going back"																
																			aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
																			aMotionCursor forward: false.
																		].		
				
					] ifFalse: [  
						
						(aMotionCursor subjectCursor  < aMotionCursor subjectSize ) ifTrue:[
						
						
						newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ].
					 
					
							(newContexts anySatisfy: #isMatch) ifTrue: [ 			
										contexts := newContexts. 
										aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
										aMotionCursor subjectCursor: aMotionCursor subjectCursor + 1.		
										aMotionCursor forward: true.																		
							]
					 
							
						] ifFalse:[
							aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
							aMotionCursor subjectCursor: aMotionCursor subjectCursor - 1.		
							aMotionCursor forward: false.
						].
					].
												
			] 
			ifTrue: [ | start min max length subjects |
				
				"Set values of start min max ... before start using them"
				
				aMotionCursor forward ifTrue:[
					"start = subjectCursor "
					aMotionCursor lvStarts at: aMotionCursor patternCursor put: aMotionCursor subjectCursor.
					
					"length of subjects to retrieve from original subjects list to match is:"
					
					(aMotionCursor patternCursor = aMotionCursor patternSize) ifTrue: [  
						"if patternCursor is on last element then length = subjectSize - subjectCursor"
						aMotionCursor lvLengths at:aMotionCursor patternCursor put: (aMotionCursor subjectSize - (aMotionCursor subjectCursor - 1)).
					]
					ifFalse: [  
						"if not last, then length is = min length;"
						aMotionCursor lvLengths at:aMotionCursor patternCursor put: (aMotionCursor lvMinLengths at: aMotionCursor patternCursor).						
					].				
				]
				ifFalse: [ 
					"if not forward, set forward to True and increment"
					aMotionCursor lvLengths at:aMotionCursor patternCursor put: ((aMotionCursor lvLengths at:aMotionCursor patternCursor) + 1).
					aMotionCursor forward: true.
				].
			
				
				length := aMotionCursor lvLengths at: aMotionCursor patternCursor.
				start := aMotionCursor lvStarts at: aMotionCursor patternCursor.
				min := aMotionCursor lvMinLengths at: aMotionCursor patternCursor.
				max := aMotionCursor lvMaxLengths at: aMotionCursor patternCursor.
				 
				(length > max or: ((start - 1 + length ) >= (aMotionCursor subjectSize + 1))) ifTrue:[
						"length failure --> this means we have to go back again."
						
						aMotionCursor subjectCursor: start.
						aMotionCursor forward: false.
						aMotionCursor lvLengths at: aMotionCursor patternCursor put: 0.
						
						"decrement pattern Cursor"
						aMotionCursor patternCursor: aMotionCursor patternCursor - 1.
					]
				ifFalse: [ 					
					"here we try to get subjects based on start and length"
					subjects := aCollection copyFrom: start to: (start + length -1 ).
					
					contexts := contexts flatCollect: [ :c | pattern match: subjects withContext: c ].
				 
					(contexts anySatisfy: #isMatch) ifTrue: [ 
																			"on match success: increment subject cursor"
																			aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
																			aMotionCursor subjectCursor: start + length .																		
																	] 
															 		ifFalse: [ 
																			"on match failure: go back; reset length and decrement patternCursor."
																			aMotionCursor forward: false.
																			aMotionCursor lvLengths at: aMotionCursor patternCursor put: 0.
																			aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
																		].		
					 
				].				
			].

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
