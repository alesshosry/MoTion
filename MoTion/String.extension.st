Extension { #name : #String }

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
