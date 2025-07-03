Class {
	#name : 'MatcherLiteralBoolean',
	#superclass : 'MatcherLiteral',
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'matching' }
MatcherLiteralBoolean >> match: aValue withContext: aContext [

	aContext isMatch: aValue = value.

	^ { aContext }
]
