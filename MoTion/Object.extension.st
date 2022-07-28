Extension { #name : #Object }

{ #category : #'*MoTion' }
Object >> <=> aMatcherObject [
	^ self -> aMatcherObject
]

{ #category : #'*MoTion' }
Object >> <~=> aMatcherObject [
	^  self -> (MatcherNAC of: aMatcherObject asMatcher)
]
