Class {
	#name : #MatcherMooseObject,
	#superclass : #MatcherObject,
	#category : #'MoTion-Moose-matcher'
}

{ #category : #'as yet unclassified' }
MatcherMooseObject class >> type: aClass withProperties: aPropertiesArray [

	| properties |
	properties := aPropertiesArray collect: [ :each | 
		              each key asMooseObjectPath -> each value asMatcher ].
	^ self new
		  type: aClass;
		  properties: properties;
		  yourself
]

{ #category : #testing }
MatcherMooseObject >> isMooseMatcher [

	^ true
]
