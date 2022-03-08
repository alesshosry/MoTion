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

{ #category : #accessing }
MatcherObject >> initialize [
	properties := OrderedCollection new.
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
			                (path resolveFrom: anObject) flatCollect: [ :obj | 
				                | copy |
				                copy := context copy.
				                submatcher match: obj withContext: copy ] ]) 
			               select: [ :context | context isMatch ] ].
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
