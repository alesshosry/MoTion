Class {
	#name : #MatcherLiteralBoolean,
	#superclass : #MatcherLiteral,
	#category : #'MoTion-matcher'
}

{ #category : #matching }
MatcherLiteralBoolean >> match: aValue withContext: aContext [

	aContext isMatch: aValue = value.

	^ { aContext }
]
