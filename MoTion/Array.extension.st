Extension { #name : #Array }

{ #category : #'*MoTion' }
Array >> asMatcher [
	^ MatcherCollection of: (self collect: #asMatcher).
]

{ #category : #'*MoTion' }
Array >> orMatches: aMatcher [

	^ OrMatcher between: self asMatcher and: aMatcher asMatcher
]
