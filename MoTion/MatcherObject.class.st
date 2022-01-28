Class {
	#name : #MatcherObject,
	#superclass : #Matcher,
	#instVars : [
		'type',
		'properties'
	],
	#category : #'MoTion-matcher'
}

{ #category : #'as yet unclassified' }
MatcherObject class >> type: aClass withProperties: properties [

	^ self new
		  type: aClass;
		  properties: properties;
		  yourself
]

{ #category : #accessing }
MatcherObject >> initialize [
	properties := OrderedCollection new.
]

{ #category : #accessing }
MatcherObject >> match: anObject withContext: aContext [

	| newContexts |
	anObject class = type ifFalse: [ 
		aContext isMatch: false.
		^ { aContext } ].

	"Here we are matching"
	aContext isMatch: true.
	properties ifNil: [ ^ { aContext } ].

	newContexts := { aContext }.
	properties do: [ :entry | 
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
MatcherObject >> type: aClass [

	type := aClass
]
