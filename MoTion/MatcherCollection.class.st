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
	
			"checking state of forward and cursors"
			"1- If forward and cursors reach the maximum then a match is detected: new binding (subjects combination) should be added to bindings in MatchingContext"
			
			forward ifTrue: [
				(patternCursor >= patternSize) ifTrue: [ 
					(subjectCursor >= subjectSize) ifTrue: [ 
							" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
							"match is true: here we have to add the combination list to bindings" 
							" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
							self halt.
						].
					"here we have to go forward and decrement patternCursor"
					forward := false.
					patternCursor := patternCursor - 1.
					].
				]
			ifFalse:[
				(patternCursor >= patternSize) ifTrue: [ 
					"decrement both when going back and patternCursor reached the patternSize"
					patternCursor := patternCursor - 1.
					subjectCursor := subjectCursor - 1.
				]				
			].
			
			"2- If one of the cursors is negative --> this means that no more combinations are available anymore. hasNext will be set to false and the  looping finishes"
			
			(patternCursor < 0 or: (subjectCursor <0)) ifTrue: [ 
				hasNext := false.
			].
		
			"Get pattern and start checking its type: literal or listWildcard"
			pattern := matcherSequence at: patternCursor.
			pattern isListWildcard ifFalse: [ | newContexts |

				"1- Check if going forward & patternCursor didn't reach full size"
				(forward and: [(subjectCursor < subjectSize)] ) ifTrue: [
					newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: subjectCursor) withContext: c ].
					"2- Try to match by gettiong values based on patternCursor and subjectCursor"
					
					(newContexts anySatisfy: #isMatch) ifTrue: [ 
																				"3- Increment when there is a match"
																				contexts := newContexts. 
																		  		patternCursor := patternCursor + 1.
																		  		subjectCursor := subjectCursor + 1.																				
																				] 
															 		ifFalse: [ 
																			"4- decrement patternCurso if no match and set forward to false to force going back"																
																			patternCursor := patternCursor - 1. 
																			forward := false.
																		].		
				
					] ifFalse: [  
						
						(subjectCursor  < subjectSize ) ifTrue:[
						
						
						newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: subjectCursor) withContext: c ].
					 
					
							(newContexts anySatisfy: #isMatch) ifTrue: [ 			
										contexts := newContexts. 
										patternCursor := patternCursor + 1.
										subjectCursor := subjectCursor + 1.		
										forward := true.																		
							]
					 
							
						] ifFalse:[
							patternCursor := patternCursor - 1. 
							subjectCursor := subjectCursor - 1.		
							forward := false.
						].
					].
												
			] 
			ifTrue: [ | start min max length subjects |
				
				"Set values of start min max ... before start using them"
				
				forward ifTrue:[
					"start = subjectCursor "
					lvStarts at: patternCursor put: subjectCursor.
					
					"length of subjects to retrieve from original subjects list to match is:"
					
					(patternCursor = patternCursor) ifTrue: [  
						"if patternCursor is on last element then length = subjectSize - subjectCursor"
						lvLenghts at:patternCursor put: (subjectSize - subjectCursor).
					]
					ifFalse: [  
						"if not last, then length is = min length;"
						lvLenghts at:patternCursor put: (lvMinLengths at: patternCursor).						
					].				
				]
				ifFalse: [ 
					"if not forward, set forward to True and increment"
					lvLenghts at:patternCursor put: (lvLenghts at:patternCursor).
				].
			
				
				length := lvLenghts at: patternCursor.
				start := lvStarts at: patternCursor.
				min := lvMinLengths at: patternCursor.
				max := lvMaxLengths at: patternCursor.
				
				(length > max or: ((start + length) >= (subjectSize + delta))) ifTrue:[
						"length failure --> this means we have to go back again."
						subjectCursor := start.
						forward := false.
						lvLenghts at: patternCursor = 0.
						
						"decrement pattern Cursor"
						patternCursor := patternCursor - 1.
					]
				ifFalse: [ 					
					"here we try to get subjects based on start and length"
					subjects := aCollection copyFrom: start to: length.
					contexts := contexts flatCollect: [ :c | pattern match: subjects withContext: c ].
				
					
					
					(contexts anySatisfy: #isMatch) ifTrue: [ 
																			"on match success: increment subject cursor"
																			patternCursor := patternCursor + 1.
																			subjectCursor := start + length .																		
																	] 
															 		ifFalse: [ 
																			"on match failure: go back; reset length and decrement patternCursor."
																			forward := false.
																			lvLenghts at: patternCursor = 0.
																			patternCursor := patternCursor - 1. 
																		].		
					
					
					
					
					" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
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
