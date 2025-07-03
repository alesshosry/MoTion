Extension { #name : 'Object' }

{ #category : '*MoTion' }
Object >> <=> aMatcherObject [
	^ self -> aMatcherObject
]

{ #category : '*MoTion' }
Object >> <~=> aMatcherObject [
	^  self -> (MatcherNAC of: aMatcherObject asMatcher)
]

{ #category : '*MoTion' }
Object >> case: aPattern do: aBlock [

	| matchingResult |
	matchingResult := aPattern match: self.
	matchingResult isMatch ifFalse: [ ^ self ].
	aBlock value: matchingResult.
	^ aBlock 
]

{ #category : '*MoTion' }
Object >> defaultDo: aBlock [
   ^ aBlock value.
]

{ #category : '*MoTion' }
Object >> objectDoesNotMatch: aMatcherObject [
	^  self <~=> aMatcherObject 
]

{ #category : '*MoTion' }
Object >> objectMatches: aMatcherObject [
	^ self <=> aMatcherObject
]
