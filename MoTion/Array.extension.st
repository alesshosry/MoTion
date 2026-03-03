Extension { #name : 'Array' }

{ #category : '*MoTion' }
Array >> ! aMatcher [
	^ MatcherUnorderedCollection of: (self collect: #asMatcher).

	
]

{ #category : '*MoTion' }
Array >> asMatcher [
	^ MatcherCollection of: (self collect: #asMatcher).
]

{ #category : '*MoTion' }
Array >> match: anObject [

	^ self asMatcher match: anObject
]

{ #category : '*MoTion' }
Array >> orMatches: aMatcher [

	^ OrMatcher between: self asMatcher and: aMatcher asMatcher
]
