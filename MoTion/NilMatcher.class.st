Class {
	#name : #NilMatcher,
	#superclass : #Matcher,
	#category : #'MoTion-matcher'
}

{ #category : #matching }
NilMatcher >> match: aValue withContext: aMatchingContext [

	aMatchingContext isMatch: aValue isNil.
	^ { aMatchingContext }
]
