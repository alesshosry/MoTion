Class {
	#name : #MTRecursiveChildrenPath,
	#superclass : #MotionPath,
	#category : #'MoTion-paths'
}

{ #category : #resolving }
MTRecursiveChildrenPath >> initialize [
	name := #'_*'.
	 
]

{ #category : #resolving }
MTRecursiveChildrenPath >> internalResolveFrom: anObject seen: seenObjects [

	| directObjects resultsCollection |
	
	directObjects := { } asOrderedCollection.
	(self slotsToVisit: anObject) do: [ :slot | 
		| o |
		o := slot read: anObject.
		resultsCollection := (o isCollection and: [ 
			                      o isString not and: o isSymbol not ])
			                     ifFalse: [ { o } ]
			                     ifTrue: [ o ].
		resultsCollection := resultsCollection select: [ :each | 
			                     each isNotNil and: [ 
				                     (seenObjects includes: each) not ] ].
		directObjects addAll: resultsCollection.
		seenObjects addAll: resultsCollection].

	directObjects addAll: (directObjects flatCollect: [ :each | 
			 self internalResolveFrom: each seen: seenObjects ]).
	(seenObjects includes: anObject) ifFalse: [  
		seenObjects add: anObject.
		"directObjects insert: anObject before: 1". 
	].

	^ directObjects
]

{ #category : #resolving }
MTRecursiveChildrenPath >> resolveFrom: anObject [

	^ (self internalResolveFrom: anObject seen: IdentitySet new) asArray
]

{ #category : #resolving }
MTRecursiveChildrenPath >> slotsToVisit: anObject [ 

	^ anObject class allSlots
]
