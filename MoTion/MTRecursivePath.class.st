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
