Extension { #name : #Array }

{ #category : #'*MoTion' }
Array >> asMatcher [
	^ MatcherCollection of: (self collect: #asMatcher).
]
