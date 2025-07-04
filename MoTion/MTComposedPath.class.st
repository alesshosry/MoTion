"
Composed path enables path traversal using the '>' operator between properties. This allows to chain multiple properties in a pattern. Such paths help reducing complex pattern’s expression, by accessing a chain of objects and their properties:
The following pattern first matches an instance of 'ClassA', then it takes the object in its `property1` and the value in `property2` of this second object. This value should match `aValue`.
```
ClassA % {
	#'property1>property2' <=> aValue.
}
```
"
Class {
	#name : 'MTComposedPath',
	#superclass : 'MotionPath',
	#instVars : [
		'paths'
	],
	#category : 'MoTion-paths',
	#package : 'MoTion',
	#tag : 'paths'
}

{ #category : 'instance creation' }
MTComposedPath class >> of: aCollectionOfPaths [

	^ self new
		  addAll: aCollectionOfPaths;
		  yourself
]

{ #category : 'initialization' }
MTComposedPath >> add: aMotionPath [

	paths add: aMotionPath
]

{ #category : 'initialization' }
MTComposedPath >> addAll: anCollectionOfPaths [
	paths addAll: anCollectionOfPaths 
]

{ #category : 'initialization' }
MTComposedPath >> initialize [

	paths := OrderedCollection new
]

{ #category : 'initialization' }
MTComposedPath >> resolveCollectionFrom: anObject [

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
			tmpObjects addAll: result flattened ] ].
	^ tmpObjects asArray
]

{ #category : 'initialization' }
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
			tmpObjects addAll: result flattened ] ].
	^ tmpObjects asArray
]
