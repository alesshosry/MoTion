Extension { #name : #Class }

{ #category : #'*MoTion' }
Class >> % aMatcherDescription [

	| properties |
	properties := aMatcherDescription collect: [ :each | 
		              each key asObjectPath -> each value asMatcher ].
	^ MatcherObject type: self withProperties: properties
]
