Extension { #name : #Number }

{ #category : #'*MoTion' }
Number >> asMatcher [

	^ MatcherLiteralNumber of: self
]
