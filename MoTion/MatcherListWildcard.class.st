Class {
	#name : #MatcherListWildcard,
	#superclass : #MatcherWildcard,
	#category : #'MoTion-matcher'
}

{ #category : #testing }
MatcherListWildcard >> isListWildcard [ 
	^ true
]

{ #category : #testing }
MatcherListWildcard >> match: aNewValue withContext: aMatchingContext [

	aMatchingContext isMatch: true.
	^ { aMatchingContext }
]
