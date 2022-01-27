Class {
	#name : #MotionPath,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'MoTion-paths'
}

{ #category : #resolving }
MotionPath >> name: aName [
	name := aName
]

{ #category : #resolving }
MotionPath >> resolveFrom: anObject [
	self shouldBeImplemented 
]
