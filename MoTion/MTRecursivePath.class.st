Class {
	#name : #MTRecursivePath,
	#superclass : #MotionPath,
	#instVars : [
		'path'
	],
	#category : #'MoTion-paths'
}

{ #category : #'instance creation' }
MTRecursivePath class >> of: aSymbol [

	^ self new name: aSymbol ; yourself 
]

{ #category : #resolving }
MTRecursivePath >> internalResolveFrom: anObject seen: seenObjects [

	| directObjects resultsCollection o |
	directObjects := {  } asOrderedCollection.
	o := (path resolveFrom: anObject) flattened.
	resultsCollection := (o isCollection and: [ 
		                      o isString not and: o isSymbol not ])
		                     ifFalse: [ { o } ]
		                     ifTrue: [ o ].
	resultsCollection := resultsCollection select: [ :each | 
		                     each isNotNil and: [ 
			                     (seenObjects includes: each) not ] ].
	directObjects addAll: resultsCollection.
	seenObjects addAll: resultsCollection.

	directObjects addAll: (directObjects flatCollect: [ :each | 
			 self internalResolveFrom: each seen: seenObjects ]).
	(seenObjects includes: anObject) ifFalse: [ 
		seenObjects add: anObject.
		"directObjects insert: anObject before: 1 "].

	^ directObjects
]

{ #category : #resolving }
MTRecursivePath >> internalResolveFromBak: anObject seen: seenObjects [

	| directObjects o |
	directObjects := OrderedCollection new.
	o := (path resolveFrom: anObject) flattened.
	o ifNotNil: [ 
			(seenObjects includes: o) ifFalse: [ 
				directObjects addAll: o.
				seenObjects addAll: o ]].
		
	directObjects addAll: (directObjects flatCollect: [ :each | 
			 self internalResolveFrom: each seen: seenObjects ]).

	^ directObjects flattened 
]

{ #category : #resolving }
MTRecursivePath >> name: aSymbol [

	name := aSymbol.
	path := aSymbol asObjectPath
]

{ #category : #resolving }
MTRecursivePath >> resolveFrom: anObject [

	^ (self internalResolveFrom: anObject seen: IdentitySet new) asArray
]

{ #category : #resolving }
MTRecursivePath >> slotsToVisit: anObject [ 
	
	^ {anObject class slotNamed: name }
]
