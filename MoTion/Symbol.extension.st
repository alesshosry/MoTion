Extension { #name : #Symbol }

{ #category : #'*MoTion' }
Symbol >> asMatcher [
	
	(self beginsWith: '@') ifTrue: [ 
		^ MatcherWildcard of: (self withoutPrefix: '@') ].
	^ MatcherLiteralSymbol of: self
 
]
