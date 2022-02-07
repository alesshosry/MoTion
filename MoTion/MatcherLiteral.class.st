"
""Matcher Literal has multiple subclasses such as Number, String and Symbol and is resposible of matching only literals. The matcher literal has a common instance 'value' that is used in all literal matchers.""
"
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
