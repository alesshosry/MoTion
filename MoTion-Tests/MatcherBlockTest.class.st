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
	matcher := MatcherBlock of: [ :myVal |  myVal + 1 ].	 
	self assert: matcher block  equals: [ :myVal |  myVal + 1 ]. 
]
