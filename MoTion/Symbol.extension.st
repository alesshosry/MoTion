Extension { #name : #Symbol }

{ #category : #'*MoTion' }
Symbol >> asMatcher [

	^ MatcherLiteralSymbol of: self
]
