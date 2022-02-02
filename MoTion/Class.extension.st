Extension { #name : #Class }

{ #category : #'*MoTion' }
Class >> % aMatcherDescription [

	((self allSuperclasses collect: #name) includes: #MooseObject) 
		ifTrue: [ 
		^ MatcherMooseObject type: self withProperties: aMatcherDescription ].
	^ MatcherObject type: self withProperties: aMatcherDescription
]
