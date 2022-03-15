Class {
	#name : #MatcherObject,
	#superclass : #Matcher,
	#instVars : [
		'type',
		'properties',
		'subclassmatch'
	],
	#category : #'MoTion-matcher'
}

{ #category : #'instance creation' }
MatcherObject class >> type: aClass withProperties: aPropertiesArray [

	| properties |
	properties := aPropertiesArray collect: [ :each | 
		              each key asObjectPath -> each value asMatcher ].
	^ self new
		  type: aClass;
		  properties: properties;
		  yourself
]

{ #category : #initialization }
MatcherObject >> initialize [

	super initialize.
	properties := OrderedCollection new.
	subclassmatch := false
]

{ #category : #matching }
MatcherObject >> match: anObject withContext: aContext [

	| newContexts sametype |
	sametype := subclassmatch
		            ifTrue: [ anObject isKindOf: type ]
		            ifFalse: [ anObject class = type ].

	sametype ifFalse: [ 
		aContext isMatch: false.
		^ { aContext } ].

	"Here we are matching"
	aContext isMatch: true.

	newContexts := { aContext }.
	(properties sort: [ :a :b | a value isBlockMatcher not ]) do: [ 
		:entry | 
		| path submatcher |
		path := entry key.
		submatcher := entry value.
		newContexts := (newContexts flatCollect: [ :context | 
			                | copy |
			                copy := context copy.
			                submatcher isCollectionMatcher
				                ifFalse: [ 
					                (path resolveFrom: anObject) flatCollect: [ :obj | 
						                submatcher match: obj withContext: copy ] ]
				                ifTrue: [ 
				                submatcher
					                match: (path resolveFrom: anObject)
					                withContext: copy ] ]) select: [ :context | 
			               context isMatch ] ].
	^ newContexts
]

{ #category : #accessing }
MatcherObject >> properties: aCollectionOfProperties [

	properties := aCollectionOfProperties
]

{ #category : #accessing }
MatcherObject >> subclassmatch: aBoolean [

	subclassmatch := aBoolean
]

{ #category : #accessing }
MatcherObject >> type: aClass [

	type := aClass
]
