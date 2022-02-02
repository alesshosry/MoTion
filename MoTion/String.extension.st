Extension { #name : #String }

{ #category : #'*MoTion' }
String >> asMatcher [

	^ MatcherLiteralString of: self
]

{ #category : #'*MoTion' }
String >> asMooseObjectPath [

	| symbol |
	symbol := self asSymbol.
	symbol = #_ ifTrue: [ ^ MTDirectMooseChildrenPath new ].
	symbol = #'_*' ifTrue: [ ^ MTRecursiveMooseChildrenPath new ].
	^ self asObjectPath
]

{ #category : #'*MoTion' }
String >> asObjectPath [

	| symbol |
	symbol := self asSymbol.
	symbol = #_ ifTrue: [ ^ MTDirectChildrenPath new ].
	symbol = #'_*' ifTrue: [ ^ MTRecursiveChildrenPath new ].
	(symbol includes: $>) ifTrue: [ 
		^ MTComposedPath of:
			  ((symbol splitOn: '>') collect: [ :each | each asObjectPath ]) ].
	^ MTDirectPath of: symbol
]
