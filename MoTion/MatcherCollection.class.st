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

	| contexts motionCursor |
	 
	motionCursor := MotionCursor new. 
	self initializeCursor: motionCursor withCollection: aCollection.
	self setCursorLengths: motionCursor.
	
	contexts := { aMatchingContext copy }.
	[ motionCursor hasNext ] whileTrue: [ | pattern |
	  
			"checking state of forward and cursors"
			"1- If forward and cursors reach the maximum then a match is detected: new binding (subjects combination) should be added to bindings in MatchingContext"
			
			motionCursor forward ifTrue: [
				(motionCursor patternCursor > motionCursor patternSize) ifTrue: [ 
					(motionCursor subjectCursor > motionCursor subjectSize) ifTrue: [ 
							" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
							"match is true: here we have to add the combination list to bindings" 
							" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
							 self halt. 
						].
					"here we have to go forward and decrement patternCursor"
					motionCursor forward: false.
					motionCursor patternCursor: motionCursor patternCursor - 1.
					].
				]
			ifFalse:[
				(motionCursor patternCursor >= motionCursor patternSize) ifTrue: [ 
					"decrement both when going back and patternCursor reached the patternSize"
					motionCursor patternCursor: motionCursor patternCursor - 1.
					motionCursor subjectCursor: motionCursor subjectCursor - 1.
				]					
			].
			
			"2- If one of the cursors is negative --> this means that no more combinations are available anymore. hasNext will be set to false and the  looping finishes"
			
			(motionCursor patternCursor < 0 or: (motionCursor subjectCursor <0)) ifTrue: [ 
				motionCursor hasNext: false.
			
			].
		
			"Get pattern and start checking its type: literal or listWildcard"
			pattern := matcherSequence at: motionCursor patternCursor.
			pattern isListWildcard ifFalse: [ | newContexts |

				"1- Check if going forward & patternCursor didn't reach full size"
				(motionCursor forward and: [(motionCursor subjectCursor < motionCursor subjectSize)] ) ifTrue: [
					newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: motionCursor subjectCursor) withContext: c ].
					"2- Try to match by gettiong values based on patternCursor and subjectCursor"
					
					(newContexts anySatisfy: #isMatch) ifTrue: [ 
																				"3- Increment when there is a match"
																				contexts := newContexts. 
																		  		motionCursor patternCursor: motionCursor patternCursor + 1.
																		  		motionCursor subjectCursor: motionCursor subjectCursor + 1.																				
																				] 
															 		ifFalse: [ 
																			"4- decrement patternCurso if no match and set forward to false to force going back"																
																			motionCursor patternCursor: motionCursor patternCursor - 1. 
																			motionCursor forward: false.
																		].		
				
					] ifFalse: [  
						
						(motionCursor subjectCursor  < motionCursor subjectSize ) ifTrue:[
						
						
						newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: motionCursor subjectCursor) withContext: c ].
					 
					
							(newContexts anySatisfy: #isMatch) ifTrue: [ 			
										contexts := newContexts. 
										motionCursor patternCursor: motionCursor patternCursor + 1.
										motionCursor subjectCursor: motionCursor subjectCursor + 1.		
										motionCursor forward: true.																		
							]
					 
							
						] ifFalse:[
							motionCursor patternCursor: motionCursor patternCursor - 1. 
							motionCursor subjectCursor: motionCursor subjectCursor - 1.		
							motionCursor forward: false.
						].
					].
												
			] 
			ifTrue: [ | start min max length subjects |
				
				"Set values of start min max ... before start using them"
				
				motionCursor forward ifTrue:[
					"start = subjectCursor "
					motionCursor lvStarts at: motionCursor patternCursor put: motionCursor subjectCursor.
					
					"length of subjects to retrieve from original subjects list to match is:"
					
					(motionCursor patternCursor = motionCursor patternSize) ifTrue: [  
						"if patternCursor is on last element then length = subjectSize - subjectCursor"
						motionCursor lvLengths at:motionCursor patternCursor put: (motionCursor subjectSize - (motionCursor subjectCursor - 1)).
					]
					ifFalse: [  
						"if not last, then length is = min length;"
						motionCursor lvLengths at:motionCursor patternCursor put: (motionCursor lvMinLengths at: motionCursor patternCursor).						
					].				
				]
				ifFalse: [ 
					"if not forward, set forward to True and increment"
					motionCursor lvLengths at:motionCursor patternCursor put: ((motionCursor lvLengths at:motionCursor patternCursor) + 1).
					motionCursor forward: true.
				].
			
				
				length := motionCursor lvLengths at: motionCursor patternCursor.
				start := motionCursor lvStarts at: motionCursor patternCursor.
				min := motionCursor lvMinLengths at: motionCursor patternCursor.
				max := motionCursor lvMaxLengths at: motionCursor patternCursor.
				 
				(length > max or: ((start - 1 + length ) >= (motionCursor subjectSize + 1))) ifTrue:[
						"length failure --> this means we have to go back again."
						
						motionCursor subjectCursor: start.
						motionCursor forward: false.
						motionCursor lvLengths at: motionCursor patternCursor put: 0.
						
						"decrement pattern Cursor"
						motionCursor patternCursor: motionCursor patternCursor - 1.
					]
				ifFalse: [ 					
					"here we try to get subjects based on start and length"
					subjects := aCollection copyFrom: start to: (start + length -1 ).
					contexts := contexts flatCollect: [ :c | pattern match: subjects withContext: c ].
				 
					(contexts anySatisfy: #isMatch) ifTrue: [ 
																			"on match success: increment subject cursor"
																			motionCursor patternCursor: motionCursor patternCursor + 1.
																			motionCursor subjectCursor: start + length .																		
																	] 
															 		ifFalse: [ 
																			"on match failure: go back; reset length and decrement patternCursor."
																			motionCursor forward: false.
																			motionCursor lvLengths at: motionCursor patternCursor put: 0.
																			motionCursor patternCursor: motionCursor patternCursor - 1. 
																		].		
					 
				].				
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
