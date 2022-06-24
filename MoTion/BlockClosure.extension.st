Extension { #name : #BlockClosure }

{ #category : #'*MoTion' }
BlockClosure >> asMatcher [

	^ MatcherBlock of: self
]

{ #category : #'*MoTion' }
BlockClosure >> match: anObject [

	^ self asMatcher match: anObject
]

{ #category : #'*MoTion' }
BlockClosure >> orMatches: aMatcher [

	^ OrMatcher between: self asMatcher and: aMatcher asMatcher
]
