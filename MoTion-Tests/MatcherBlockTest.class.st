Class {
	#name : #MatcherBlockTest,
	#superclass : #MatcherTests,
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : #'MoTion-Tests-matchers'
}

{ #category : #tests }
MatcherBlockTest >> testBlockCreation [

	| matcher |
	b := [ :myVal |  myVal + 1 ].
	matcher := MatcherBlock of: b.	 
	self assert: matcher block  equals: b. 
]
