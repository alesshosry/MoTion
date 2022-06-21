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

	| array |
	aMotionCursor subjectSize: aCollection size.
	aMotionCursor patternSize: matcherSequence size.
	aMotionCursor lvStarts: (Array new: aMotionCursor patternSize). 
	aMotionCursor lvLengths: (Array new: aMotionCursor patternSize).
	aMotionCursor lvMinLengths: (Array new: aMotionCursor patternSize).
	aMotionCursor lvMaxLengths: (Array new: aMotionCursor patternSize).
	aMotionCursor subjectCursor: 1.
	aMotionCursor patternCursor: 1.
	aMotionCursor numberOfNonListWildcards: aMotionCursor patternSize - self listWildcardPositions size.
	aMotionCursor combinationNotFound: true.  
	aMotionCursor aMatchingContextCombination: MatchingContext new.
	
	array := Array new: matcherSequence size.
	1 to: matcherSequence size do: [:i | array at: i put: OrderedCollection new]. 
	aMotionCursor contexts: (Array new: matcherSequence size).
]

{ #category : #matching }
MatcherCollection >> initializeCursor: aMotionCursor withCollection: aCollection andOriginalContext: originalContext [

	| array |
	aMotionCursor subjectSize: aCollection size.
	aMotionCursor patternSize: matcherSequence size.
	aMotionCursor lvStarts: (Array new: aMotionCursor patternSize). 
	aMotionCursor lvLengths: (Array new: aMotionCursor patternSize).
	aMotionCursor lvMinLengths: (Array new: aMotionCursor patternSize).
	aMotionCursor lvMaxLengths: (Array new: aMotionCursor patternSize).
	aMotionCursor subjectCursor: 1.
	aMotionCursor patternCursor: 1.
	aMotionCursor numberOfNonListWildcards: aMotionCursor patternSize - self listWildcardPositions size.
	aMotionCursor combinationNotFound: true.  
	aMotionCursor aMatchingContextCombination: MatchingContext new.
	aMotionCursor hasNext: true.
	
	array := Array new: matcherSequence size.
	1 to: matcherSequence size do: [:i | array at: i put: OrderedCollection new]. 
	aMotionCursor contexts: array.
	aMotionCursor originalContext: originalContext.
	
	array := Array new: matcherSequence size.
	1 to: matcherSequence size do: [:i | array at: i put: true]. 
	aMotionCursor patternHasNext: array.
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
MatcherCollection >> match: aCollection withContext: aMatchingContext [

	|  motionCursor  firstMatch results|
	 
	"results is a collection of matchingContexts"
	results := OrderedCollection  new.
	
	"initilazing the motionCursor"
	motionCursor := MotionCursor new. 	
	self initializeCursor: motionCursor withCollection: aCollection andOriginalContext: aMatchingContext.
	self setCursorLengths: motionCursor.
	
	"firstMatch is used to fill hasNext for the first time as true, then while looping the value changes only when the last combination is found"
	firstMatch := true.
		
	[ motionCursor hasNext ] whileTrue: [  	
		"We enter this loop each time a combination is found to reset combination params in moTionCursor."
	
		motionCursor forward: firstMatch.
		firstMatch := false.
		
		" restting combination params "
		motionCursor combinationNotFound: true.
		motionCursor aMatchingContextCombination: MatchingContext new.  
		 
		
		(firstMatch not and: [ motionCursor patternCursor < motionCursor patternSize ] ) ifTrue: [
			motionCursor clearContextsForCurrentPattern. 
		].
		
		[ motionCursor combinationNotFound and: (motionCursor hasNext) ] whileTrue: [  
			"here we are looping until there are no combinations found. 
			results can contains false and true matchingContexts; true macthingContexts will be filtered when isMatch is called only." 	
			(self matchNext: aCollection withCursor: motionCursor withContexts: motionCursor getContextForCurrentPattern originalContext: aMatchingContext).  
		].
	"here there should be a solution in the last cursor thingy"
	(motionCursor combinationNotFound) ifFalse: [  
		self halt.
		results addAll: motionCursor getContextForCurrentPattern.
	].
	
	
	].

	self halt.
	^ results asArray 
	
]

{ #category : #matching }
MatcherCollection >> matchNext: aCollection withCursor: aMotionCursor withContext: aMatchingContext [
| pattern contexts bindingsArray| 

contexts := { aMatchingContext copy }.  

self halt.
	"checking state of forward and cursors"
			"1- If forward and cursors reach the maximum then a combination is built "
			
			aMotionCursor forward ifTrue: [
				(aMotionCursor patternCursor > aMotionCursor patternSize) ifTrue: [ 
					(aMotionCursor subjectCursor > aMotionCursor subjectSize) ifTrue: [ 		 
							aMotionCursor combinationNotFound: false. 
							"!! here a full combination of matches is found."	  
							  self halt.
							^ aMotionCursor aMatchingContextCombination.
						].
					"here we have cannot go forward anymore as patternCursor reached the max but without matching all subjects, which is why we decrement patternCursor"
					aMotionCursor forward: false.
					aMotionCursor patternCursor: aMotionCursor patternCursor - 1.
					].
				]
			ifFalse:[
				(aMotionCursor patternCursor >= aMotionCursor patternSize) ifTrue: [ 
					"decrement both and go back and patternCursor reaches the patternSize and subjectCursor reaches subjectSize."
					aMotionCursor patternCursor: aMotionCursor patternCursor - 1.
					aMotionCursor subjectCursor: aMotionCursor subjectCursor - 1.
				]					
			]. 
		
			
			"2- If one of the cursors is negative --> this means that no more combinations are available anymore. hasNext will be set to false and the looping finishes"
			(aMotionCursor patternCursor < 1 or: [aMotionCursor subjectCursor < 1]) ifTrue: [ 
				aMotionCursor hasNext: false.	
				self halt.		 	
				^ {}
			].
		
			"Get pattern and start checking its type: literal or listWildcard"
			pattern := matcherSequence at: aMotionCursor patternCursor.
			pattern isListWildcard ifFalse: [ 
				
				| newContexts |

				"Check if going forward & patternCursor didn't reach full size"
				(aMotionCursor forward and: [(aMotionCursor subjectCursor < aMotionCursor subjectSize)] ) ifTrue: [ 
					
					"Try to match by getting values based on patternCursor and subjectCursor"					
					newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ].
										
					(newContexts anySatisfy: #isMatch) 
						ifTrue: [  
									self halt.
										"Increment when there is a match" 
										contexts := newContexts select: #isMatch.   
										aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
										aMotionCursor subjectCursor: aMotionCursor subjectCursor + 1.		
																										
									] 
						ifFalse: [ 
							self halt.
										"decrement patternCursor if no match and set forward to false to force going back; 
										Only patternCursor bcz we want to to try matching a new pattern with same subjects"	  
										aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
										aMotionCursor forward: false.
									].		
				
					] ifFalse: [   
						"in this case frward is false but we need to check if there is a match."
						(aMotionCursor subjectCursor  < aMotionCursor subjectSize ) ifTrue:[ 
						
							newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ]. 
							(newContexts anySatisfy: #isMatch) ifTrue: [ 		 
										contexts := newContexts select: #isMatch. 
										"increment everything"  
										aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
										aMotionCursor subjectCursor: aMotionCursor subjectCursor + 1.		
										aMotionCursor forward: true.																		
							] 
						
							ifFalse:[ 
								"decrement everything bcz we're in state where forward is false."
								aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
								aMotionCursor subjectCursor: aMotionCursor subjectCursor - 1.		
								aMotionCursor forward: false.
							].
											  
						] ifFalse:[ 
							"decrement everything"
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
			 
			
				"catch values and start looping"
				length := aMotionCursor lvLengths at: aMotionCursor patternCursor.
				start := aMotionCursor lvStarts at: aMotionCursor patternCursor.
				min := aMotionCursor lvMinLengths at: aMotionCursor patternCursor.
				max := aMotionCursor lvMaxLengths at: aMotionCursor patternCursor.
				 
				(length > max or: [((start - 1 + length ) >= (aMotionCursor subjectSize + 1))]) ifTrue:[
						"length failure --> this means we have to go back"
						
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
																			"on match success: increment subject cursor and get bindings as we are in wildcard case" 
																			contexts := contexts select: #isMatch.  
																			bindingsArray := contexts collect: [ :aContext | aContext bindings]  .
																			bindingsArray do:[:aBindingDict | 
																				aMotionCursor aMatchingContextCombination bindings at:pattern alias put:  (aBindingDict at: (pattern alias) ). 
																			]. 
																			aMotionCursor aMatchingContextCombination isMatch: true. 
																			aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
																			aMotionCursor subjectCursor: start + length.																		
																	] 
															 		ifFalse: [ 
																			"on match failure: go back; reset length and decrement patternCursor." 
																			aMotionCursor forward: false.
																			aMotionCursor lvLengths at: aMotionCursor patternCursor put: 0.
																			aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
																		].		
					 
				].				
			].
		
		^ {}.

]

{ #category : #matching }
MatcherCollection >> matchNext: aCollection withCursor: aMotionCursor withContexts: matchContexts [
| pattern contexts bindingsArray| 

contexts := matchContexts deepCopy .  

self halt.
	"checking state of forward and cursors"
			"1- If forward and cursors reach the maximum then a combination is built "
			
			aMotionCursor forward ifTrue: [
				(aMotionCursor patternCursor > aMotionCursor patternSize) ifTrue: [ 
					(aMotionCursor subjectCursor > aMotionCursor subjectSize) ifTrue: [ 		 
							aMotionCursor combinationNotFound: false. 
							"!! here a full combination of matches is found."	  
							  self halt.
							^ aMotionCursor aMatchingContextCombination.
						].
					"here we have cannot go forward anymore as patternCursor reached the max but without matching all subjects, which is why we decrement patternCursor"
					aMotionCursor forward: false.
					aMotionCursor patternCursor: aMotionCursor patternCursor - 1.
					contexts := { MatchingContext new }.
					].
				]
			ifFalse:[
				(aMotionCursor patternCursor >= aMotionCursor patternSize) ifTrue: [ 
					"decrement both and go back and patternCursor reaches the patternSize and subjectCursor reaches subjectSize."
					aMotionCursor patternCursor: aMotionCursor patternCursor - 1.
					aMotionCursor subjectCursor: aMotionCursor subjectCursor - 1.
				]					
			]. 
		
			
			"2- If one of the cursors is negative --> this means that no more combinations are available anymore. hasNext will be set to false and the looping finishes"
			(aMotionCursor patternCursor < 1 or: [aMotionCursor subjectCursor < 1]) ifTrue: [ 
				aMotionCursor hasNext: false.	
				self halt.		 	
				^ contexts
			].
		
			"Get pattern and start checking its type: literal or listWildcard"
			pattern := matcherSequence at: aMotionCursor patternCursor.
			pattern isListWildcard ifFalse: [ 
				
				| newContexts |

				"Check if going forward & patternCursor didn't reach full size"
				(aMotionCursor forward and: [(aMotionCursor subjectCursor < aMotionCursor subjectSize)] ) ifTrue: [ 
					
					"Try to match by getting values based on patternCursor and subjectCursor"					
					newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ].
										
					(newContexts anySatisfy: #isMatch) 
						ifTrue: [  
									self halt.
										"Increment when there is a match" 
										contexts := newContexts select: #isMatch.   
										aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
										aMotionCursor subjectCursor: aMotionCursor subjectCursor + 1.		
																										
									] 
						ifFalse: [ 
							self halt.
										"decrement patternCursor if no match and set forward to false to force going back; 
										Only patternCursor bcz we want to to try matching a new pattern with same subjects"	  
										aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
										aMotionCursor forward: false.
									].		
				
					] ifFalse: [   
						"in this case frward is false but we need to check if there is a match."
						(aMotionCursor subjectCursor  < aMotionCursor subjectSize ) ifTrue:[ 
						
							newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ]. 
							(newContexts anySatisfy: #isMatch) ifTrue: [ 		 
										contexts := newContexts select: #isMatch. 
										"increment everything"  
										aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
										aMotionCursor subjectCursor: aMotionCursor subjectCursor + 1.		
										aMotionCursor forward: true.																		
							] 
						
							ifFalse:[ 
								"decrement everything bcz we're in state where forward is false."
								aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
								aMotionCursor subjectCursor: aMotionCursor subjectCursor - 1.		
								aMotionCursor forward: false.
							].
											  
						] ifFalse:[ 
							"decrement everything"
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
			 
			
				"catch values and start looping"
				length := aMotionCursor lvLengths at: aMotionCursor patternCursor.
				start := aMotionCursor lvStarts at: aMotionCursor patternCursor.
				min := aMotionCursor lvMinLengths at: aMotionCursor patternCursor.
				max := aMotionCursor lvMaxLengths at: aMotionCursor patternCursor.
				 
				(length > max or: [((start - 1 + length ) >= (aMotionCursor subjectSize + 1))]) ifTrue:[
						"length failure --> this means we have to go back"
						
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
																			"on match success: increment subject cursor and get bindings as we are in wildcard case" 
																			contexts := contexts select: #isMatch.  
																			bindingsArray := contexts collect: [ :aContext | aContext bindings]  .
																			bindingsArray do:[:aBindingDict | 
																				aMotionCursor aMatchingContextCombination bindings at:pattern alias put:  (aBindingDict at: (pattern alias) ). 
																			]. 
																			aMotionCursor aMatchingContextCombination isMatch: true. 
																			aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
																			aMotionCursor subjectCursor: start + length.																		
																	] 
															 		ifFalse: [ 
																			"on match failure: go back; reset length and decrement patternCursor." 
																			aMotionCursor forward: false.
																			aMotionCursor lvLengths at: aMotionCursor patternCursor put: 0.
																			aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
																		].		
					 
				].				
			].
		
		^ contexts.

]

{ #category : #matching }
MatcherCollection >> matchNext: aCollection withCursor: aMotionCursor withContexts: matchContexts originalContext: originalContext [
| pattern contexts | 

contexts := matchContexts deepCopy .  

	"checking state of forward and cursors"
			"1- If forward and cursors reach the maximum then a combination is built "
			
			aMotionCursor forward ifTrue: [
				(aMotionCursor patternCursor > aMotionCursor patternSize) ifTrue: [ 
					(aMotionCursor subjectCursor > aMotionCursor subjectSize) ifTrue: [ 		 
							aMotionCursor combinationNotFound: false. 
							"!! here a full combination of matches is found."	 
							^ contexts.
						].
					"here we have cannot go forward anymore as patternCursor reached the max but without matching all subjects, which is why we decrement patternCursor"
					aMotionCursor forward: false.
					aMotionCursor patternCursor: aMotionCursor patternCursor - 1.
					aMotionCursor clearContextsForCurrentPattern.
					].
				]
			ifFalse:[
				(aMotionCursor patternCursor >= aMotionCursor patternSize) ifTrue: [ 
					"decrement both and go back and patternCursor reaches the patternSize and subjectCursor reaches subjectSize."
					
					aMotionCursor patternCursor: aMotionCursor patternCursor - 1.
					aMotionCursor subjectCursor: aMotionCursor subjectCursor - 1.
				]					
			]. 
		
			
			"2- If one of the cursors is negative --> this means that no more combinations are available anymore. hasNext will be set to false and the looping finishes"
			(aMotionCursor patternCursor < 1 or: [aMotionCursor subjectCursor < 1]) ifTrue: [ 
				aMotionCursor hasNext: false.
				^ contexts
			].
		
			"Get pattern and start checking its type: literal or listWildcard"
			pattern := matcherSequence at: aMotionCursor patternCursor.
			pattern isListWildcard ifFalse: [ 
				
				| newContexts |

				"Check if going forward & patternCursor didn't reach full size"
				(aMotionCursor forward and: [(aMotionCursor subjectCursor <= aMotionCursor subjectSize)] ) ifTrue: [ 
					
					aMotionCursor resetHasNextForCurrentPattern.
					"Try to match by getting values based on patternCursor and subjectCursor"					
					newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ].
										
					(newContexts anySatisfy: #isMatch) 
						ifTrue: [  
										"Increment when there is a match"
										aMotionCursor setHasNextForCurrentPattern.
										contexts := newContexts select: #isMatch. 
										aMotionCursor addContextToPattern: contexts.
										self halt.
										aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
										aMotionCursor subjectCursor: aMotionCursor subjectCursor + 1.		
																										
									] 
						ifFalse: [ 
										"decrement patternCursor if no match and set forward to false to force going back; 
										Only patternCursor bcz we want to to try matching a new pattern with same subjects"	 
										
										aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
										aMotionCursor forward: false.
										aMotionCursor clearContextsForCurrentPattern.
									].		
				
					] ifFalse: [   
						"in this case frward is false but we need to check if there is a match."
						(aMotionCursor subjectCursor  <= aMotionCursor subjectSize ) ifTrue:[ 
						
							newContexts := contexts flatCollect: [ :c | pattern match: (aCollection at: aMotionCursor subjectCursor) withContext: c ]. 
							(aMotionCursor hasNextForCurrentPattern and: [(newContexts anySatisfy: #isMatch)]) ifTrue: [ 		 
										contexts := newContexts select: #isMatch. 
										aMotionCursor resetHasNextForCurrentPattern.
										"increment everything"
										aMotionCursor addContextToPattern: contexts.
										self halt.
										aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
										aMotionCursor subjectCursor: aMotionCursor subjectCursor + 1.		
										aMotionCursor forward: true.																		
							] 
						
							ifFalse:[ 
								"decrement everything bcz we're in state where forward is false."
								
								aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
								aMotionCursor subjectCursor: aMotionCursor subjectCursor - 1.
								aMotionCursor forward: false.
							].
											  
						] ifFalse:[ 
							"decrement everything"
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
					aMotionCursor clearContextsForCurrentPattern.
				].
			 
			
				"catch values and start looping"
				length := aMotionCursor lvLengths at: aMotionCursor patternCursor.
				start := aMotionCursor lvStarts at: aMotionCursor patternCursor.
				min := aMotionCursor lvMinLengths at: aMotionCursor patternCursor.
				max := aMotionCursor lvMaxLengths at: aMotionCursor patternCursor.
				 
				(length > max or: [((start - 1 + length ) >= (aMotionCursor subjectSize + 1))]) ifTrue:[
						"length failure --> this means we have to go back"
						
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
																			"on match success: increment subject cursor and get bindings as we are in wildcard case" 
																			contexts := contexts select: #isMatch.  
																			aMotionCursor addContextToPattern: contexts.
																			self halt.
																			aMotionCursor patternCursor: aMotionCursor patternCursor + 1.
																			aMotionCursor subjectCursor: start + length.															
																	] 
															 		ifFalse: [ 
																			"on match failure: go back; reset length and decrement patternCursor." 
																			aMotionCursor forward: false.
																			aMotionCursor lvLengths at: aMotionCursor patternCursor put: 0.
																			aMotionCursor patternCursor: aMotionCursor patternCursor - 1. 
																		].		
					 
				].				
			].
		
		^ contexts.

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
