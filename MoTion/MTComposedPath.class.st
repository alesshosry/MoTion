Class {
	#name : #MTComposedPath,
	#superclass : #MotionPath,
	#instVars : [
		'paths'
	],
	#category : #'MoTion-paths'
}

{ #category : #'instance creation' }
MTComposedPath class >> of: aCollectionOfPaths [

	^ self new
		  addAll: aCollectionOfPaths;
		  yourself
]

{ #category : #initialization }
MTComposedPath >> add: aMotionPath [

	paths add: aMotionPath
]

{ #category : #initialization }
MTComposedPath >> addAll: anCollectionOfPaths [
	paths addAll: anCollectionOfPaths 
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
			| result |
			result := [ each resolveFrom: intermediate ]
				          on: Exception
				          do: [ #(  ) ].
			tmpObjects addAll: result ] ].
	^ tmpObjects asArray
]
