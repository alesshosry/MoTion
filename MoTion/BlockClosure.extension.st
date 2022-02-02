Extension { #name : #BlockClosure }

{ #category : #'*MoTion' }
BlockClosure >> asMatcher [

	^ MatcherBlock of: self
]
