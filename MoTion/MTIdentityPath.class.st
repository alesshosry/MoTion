Class {
	#name : 'MTIdentityPath',
	#superclass : 'MotionPath',
	#category : 'MoTion-paths',
	#package : 'MoTion',
	#tag : 'paths'
}

{ #category : 'initialization' }
MTIdentityPath >> initialize [
	name := #@.
]

{ #category : 'initialization' }
MTIdentityPath >> resolveFrom: anObject [
	^ { anObject } asArray 
]
