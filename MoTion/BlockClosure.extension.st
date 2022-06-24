Extension { #name : #BlockClosure }

{ #category : #'*MoTion' }
BlockClosure >> asMatcher [

	^ MatcherBlock of: self
]

{ #category : #'*MoTion' }
BlockClosure >> orMatches: aMatcher [

	^ OrMatcher between: self asMatcher and: aMatcher asMatcher
]
