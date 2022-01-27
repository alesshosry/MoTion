Class {
	#name : #MTRecursiveChildrenPathTests,
	#superclass : #MotionPathTests,
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : #'MoTion-Tests-paths'
}

{ #category : #running }
MTRecursiveChildrenPathTests >> setUp [

	super setUp.

	a := MTTestObjectA new.
	b := MTTestObjectB new.
	c := MTTestObjectC new.

	a b: b.
	a c: c.
	b c: c.
	c a: a
]

{ #category : #running }
MTRecursiveChildrenPathTests >> testRecursivePath [

	| path |
	path := MTRecursiveChildrenPath new.

	self assertCollection: (path resolveFrom: a) hasSameElements: { 
			a.
			b.
			c }
]
