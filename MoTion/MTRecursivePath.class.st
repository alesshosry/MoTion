Class {
	#name : #MTRecursivePath,
	#superclass : #MTRecursiveChildrenPath,
	#category : #'MoTion-paths'
}

{ #category : #'instance creation' }
MTRecursivePath class >> of: aSymbol [

	^ self new name: aSymbol ; yourself 
]

{ #category : #resolving }
MTRecursivePath >> slotsToVisit: anObject [ 
	
	^ {anObject class slotNamed: name }
]
