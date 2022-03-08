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

	| directObjects |
	directObjects := OrderedCollection new.
	(self slotsToVisit: anObject)  do: [ :slot | 
		| o |
		o := slot read: anObject.
		o ifNotNil: [ 
			(seenObjects includes: o) ifFalse: [ 
				directObjects add: o.
				seenObjects add: o ] ] ].

	directObjects addAll: (directObjects flatCollect: [ :each | 
			 self internalResolveFrom: each seen: seenObjects ]).

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
