Extension { #name : #Association }

{ #category : #'*MoTion' }
Association >> % matcherProperties [

	self value: self value % matcherProperties
]

{ #category : #'*MoTion' }
Association >> %% matcherProperties [

	self value: self value %% matcherProperties
]

{ #category : #'*MoTion' }
Association >> as: aSymbol [

	self value: (MatcherSave of: self value withAlias: aSymbol)
]

{ #category : #'*MoTion' }
Association >> orMatches: anObject [

	self value: (self value asMatcher orMatches: anObject asMatcher)
]
