Extension { #name : #MooseEntity }

{ #category : #'*MoTion' }
MooseEntity >> computeAllChildren [

	| allChildren |
	allChildren := self computeChildren.
	allChildren addAll:
		(allChildren flatCollect: [ :each | each computeChildren ]).
	^ allChildren
]

{ #category : #'*MoTion' }
MooseEntity >> computeChildren [

	| childrenProperties |
	childrenProperties := self mooseDescription allProperties select: #isChildrenProperty.

	^ childrenProperties flatCollectAsSet: [ :each | 
		  (self perform: each name)
			  ifNotNil: [ :r | 
				  each isMultivalued
					  ifTrue: [ r ]
					  ifFalse: [ { r } ] ]
			  ifNil: [ {  } ] ]
]
