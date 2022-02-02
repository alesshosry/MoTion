Class {
	#name : #MTRecursiveMooseChildrenPath,
	#superclass : #MTRecursiveChildrenPath,
	#category : #'MoTion-paths'
}

{ #category : #testing }
MTRecursiveMooseChildrenPath >> isMooseObjectPath [

	^ true
]

{ #category : #testing }
MTRecursiveMooseChildrenPath >> resolveFrom: anObject [

	^ anObject computeAllChildren asArray
]
