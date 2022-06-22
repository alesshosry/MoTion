Class {
	#name : #MotionCursor,
	#superclass : #Object,
	#instVars : [
		'subjectCursor',
		'subjectSize',
		'patternCursor',
		'patternSize',
		'hasNext',
		'combinationNotFound',
		'forward',
		'lvStarts',
		'lvLengths',
		'lvMinLengths',
		'lvMaxLengths',
		'numberOfNonListWildcards',
		'aMatchingContextCombination',
		'contexts',
		'originalContext',
		'patternHasNext'
	],
	#category : #'MoTion-paths'
}

{ #category : #accessing }
MotionCursor >> aMatchingContextCombination [

	^ aMatchingContextCombination
]

{ #category : #accessing }
MotionCursor >> aMatchingContextCombination: anObject [

	aMatchingContextCombination := anObject
]

{ #category : #accessing }
MotionCursor >> addContextToPattern: manyContexts [
	(contexts at: self patternCursor) addAll: manyContexts.
]

{ #category : #accessing }
MotionCursor >> clearContextsForCurrentPattern [
	| index |
	index := self patternCursor.
	index < 1 ifTrue: [ ^ self ].
	(contexts at: self patternCursor) removeAll.
]

{ #category : #accessing }
MotionCursor >> combinationNotFound [

	^ combinationNotFound
]

{ #category : #accessing }
MotionCursor >> combinationNotFound: anObject [

	combinationNotFound := anObject
]

{ #category : #accessing }
MotionCursor >> contexts [
	^ contexts
]

{ #category : #accessing }
MotionCursor >> contexts: aCollection [ 
	contexts := aCollection
]

{ #category : #accessing }
MotionCursor >> forward [

	^ forward
]

{ #category : #accessing }
MotionCursor >> forward: anObject [

	forward := anObject
]

{ #category : #accessing }
MotionCursor >> getContextForCurrentPattern [
	^ self getContextForPattern: (self patternCursor - 1)
]

{ #category : #accessing }
MotionCursor >> getContextForPattern: aNumber [
	aNumber <=0 ifTrue: [ ^ { originalContext } ].
	^ contexts at: aNumber
]

{ #category : #accessing }
MotionCursor >> hasNext [

	^ hasNext
]

{ #category : #accessing }
MotionCursor >> hasNext: anObject [

	hasNext := anObject
]

{ #category : #accessing }
MotionCursor >> hasNextForCurrentPattern [
	^ patternHasNext at: self patternCursor
]

{ #category : #accessing }
MotionCursor >> lvLengths [

	^ lvLengths
]

{ #category : #accessing }
MotionCursor >> lvLengths: anObject [

	lvLengths := anObject
]

{ #category : #accessing }
MotionCursor >> lvMaxLengths [

	^ lvMaxLengths
]

{ #category : #accessing }
MotionCursor >> lvMaxLengths: anObject [

	lvMaxLengths := anObject
]

{ #category : #accessing }
MotionCursor >> lvMinLengths [

	^ lvMinLengths
]

{ #category : #accessing }
MotionCursor >> lvMinLengths: anObject [

	lvMinLengths := anObject
]

{ #category : #accessing }
MotionCursor >> lvStarts [

	^ lvStarts
]

{ #category : #accessing }
MotionCursor >> lvStarts: anObject [

	lvStarts := anObject
]

{ #category : #accessing }
MotionCursor >> numberOfNonListWildcards [

	^ numberOfNonListWildcards
]

{ #category : #accessing }
MotionCursor >> numberOfNonListWildcards: anObject [

	numberOfNonListWildcards := anObject
]

{ #category : #accessing }
MotionCursor >> originalContext [
	^ originalContext
]

{ #category : #accessing }
MotionCursor >> originalContext: ctx [

	originalContext := ctx
]

{ #category : #accessing }
MotionCursor >> patternCursor [

	^ patternCursor
]

{ #category : #accessing }
MotionCursor >> patternCursor: anObject [

	patternCursor := anObject
]

{ #category : #accessing }
MotionCursor >> patternHasNext [

	^ patternHasNext
]

{ #category : #accessing }
MotionCursor >> patternHasNext: aCollection [
	patternHasNext := aCollection
]

{ #category : #accessing }
MotionCursor >> patternSize [

	^ patternSize
]

{ #category : #accessing }
MotionCursor >> patternSize: anObject [

	patternSize := anObject
]

{ #category : #accessing }
MotionCursor >> resetHasNextForCurrentPattern [

	patternHasNext at: self patternCursor put: true
]

{ #category : #accessing }
MotionCursor >> setHasNextForCurrentPattern [

	patternHasNext at: self patternCursor put: false
]

{ #category : #accessing }
MotionCursor >> subjectCursor [

	^ subjectCursor
]

{ #category : #accessing }
MotionCursor >> subjectCursor: anObject [

	subjectCursor := anObject
]

{ #category : #accessing }
MotionCursor >> subjectSize [

	^ subjectSize
]

{ #category : #accessing }
MotionCursor >> subjectSize: anObject [

	subjectSize := anObject
]
