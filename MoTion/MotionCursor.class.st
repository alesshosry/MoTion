Class {
	#name : #MotionCursor,
	#superclass : #Object,
	#instVars : [
		'subjectCursor',
		'subjectSize',
		'patternCursor',
		'patternSize',
		'hasNext',
		'forward',
		'lvStarts',
		'lvLengths',
		'lvMinLengths',
		'lvMaxLengths',
		'numberOfNonListWildcards'
	],
	#category : #'MoTion-paths'
}

{ #category : #accessing }
MotionCursor >> forward [

	^ forward
]

{ #category : #accessing }
MotionCursor >> forward: anObject [

	forward := anObject
]

{ #category : #accessing }
MotionCursor >> hasNext [

	^ hasNext
]

{ #category : #accessing }
MotionCursor >> hasNext: anObject [

	hasNext := anObject
]

{ #category : #initialization }
MotionCursor >> initialize [
	
	super initialize.
	
	hasNext := true.
	forward := true.
	subjectCursor := 1.
	patternCursor := 1.
	
	
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
MotionCursor >> patternCursor [

	^ patternCursor
]

{ #category : #accessing }
MotionCursor >> patternCursor: anObject [

	patternCursor := anObject
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
