Class {
	#name : #AndMatcher,
	#superclass : #LogicalMatcher,
	#category : #'MoTion-matcher'
}

{ #category : #matching }
AndMatcher >> match: aValue withContext: aMatchingContext [

	| results |
	results := left match: aValue withContext: aMatchingContext.
	(results anySatisfy: #isMatch) ifFalse: [ ^ results ].
	^ results flatCollect: [ :ctx | right match: aValue withContext: ctx ]
]
