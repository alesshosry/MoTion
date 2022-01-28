Class {
	#name : #MatcherLiteral,
	#superclass : #Matcher,
	#instVars : [
		'value'
	],
	#category : #'MoTion-matcher'
}

{ #category : #'instance creation' }
MatcherLiteral class >> of: aValue [

	^ self new
		  value: aValue;
		  yourself
]

{ #category : #accessing }
MatcherLiteral >> value [

	^ value
]

{ #category : #accessing }
MatcherLiteral >> value: aValue [

	value := aValue 
]
