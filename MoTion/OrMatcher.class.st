Class {
	#name : 'OrMatcher',
	#superclass : 'LogicalMatcher',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'matching' }
OrMatcher >> match: aValue withContext: aMatchingContext [

	| results |
	results := left match: aValue withContext: aMatchingContext.
	(results anySatisfy: #isMatch) ifTrue: [ ^ results ].
	^ right match: aValue withContext: aMatchingContext
]
