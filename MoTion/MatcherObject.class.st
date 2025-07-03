"
To define an object pattern, one specifies its type using the Pharo class followed by the percentage or double percentage operator like in: `ClassA % {}``. ‘%’ matches direct instances of the class, whereas ‘%%’ matches instances of the class or any of its subclasses.

These two operators can express sub-patterns and the properties of the matched object inside the curly braces. Object properties are instance variable accessors. The curly braces act as a conjunction of sub-patterns specifying the values that properties should match. It can be seen as a Logical matcher.
The following pattern matches an object of class `ClassA`, with a property `property1` having the value `aValue1`, and `property2` having `aValue2`:
```
ClassA % {
   #’property1’ <=> aValue1.
   #’property2’ <=> aValue2.
}
```
The sub-patterns could also be more complex (Nested pattern). This mechanism contributes to the seamless addition of various properties, in a declarative way.

"
Class {
	#name : 'MatcherObject',
	#superclass : 'Matcher',
	#instVars : [
		'type',
		'properties',
		'subclassmatch'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherObject class >> type: aClass withProperties: aPropertiesArray [

	| properties |
	properties := aPropertiesArray collect: [ :each | 
		              each key asObjectPath -> each value asMatcher ].
	^ self new
		  type: aClass;
		  properties: properties;
		  yourself
]

{ #category : 'initialization' }
MatcherObject >> initialize [

	super initialize.
	properties := OrderedCollection new.
	subclassmatch := false
]

{ #category : 'matching' }
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
			                submatcher isCollectionMatcher
				                ifFalse: [ 
					                (path resolveFrom: anObject) flatCollect: [ :obj | 
						                | copy |
						                copy := context copy.
						                submatcher match: obj withContext: copy ] ]
				                ifTrue: [ 
					                | copy |
					                copy := context copy.
					                submatcher
						                match: (path resolveFrom: anObject)
						                withContext: copy ] ]) select: #isMatch ].
	^ newContexts
]

{ #category : 'accessing' }
MatcherObject >> properties: aCollectionOfProperties [

	properties := aCollectionOfProperties
]

{ #category : 'accessing' }
MatcherObject >> subclassmatch: aBoolean [

	subclassmatch := aBoolean
]

{ #category : 'accessing' }
MatcherObject >> type: aClass [

	type := aClass
]
