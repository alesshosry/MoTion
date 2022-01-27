Class {
	#name : #MTComposedPath,
	#superclass : #MotionPath,
	#instVars : [
		'paths'
	],
	#category : #'MoTion-paths'
}

{ #category : #initialization }
MTComposedPath >> addPath: aMotionPath [

	paths add: aMotionPath
]

{ #category : #initialization }
MTComposedPath >> initialize [

	paths := OrderedCollection new
]

{ #category : #initialization }
MTComposedPath >> resolveFrom: anObject [

	| tmpObjects copy |
	tmpObjects := { anObject } asOrderedCollection.
	paths do: [ :each | 
		copy := tmpObjects shallowCopy.
		tmpObjects removeAll.
		copy do: [ :intermediate | 
			tmpObjects addAll: (each resolveFrom: intermediate) ] ].
	^ tmpObjects
]
