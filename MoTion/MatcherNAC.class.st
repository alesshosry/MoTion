Class {
	#name : #MatcherNAC,
	#superclass : #Matcher,
	#instVars : [
		'innerMatcher'
	],
	#category : #'MoTion-matcher'
}

{ #category : #'instance creation' }
MatcherNAC class >> of: aMatcher [

	^ self new innerMatcher: aMatcher
]

{ #category : #accessors }
MatcherNAC >> % aMatcher [
	innerMatcher := innerMatcher % aMatcher.
	^ self 
]

{ #category : #accessors }
MatcherNAC >> %% aMatcher [
	innerMatcher := innerMatcher %% aMatcher.
	^ self 
]

{ #category : #accessors }
MatcherNAC >> innerMatcher: aMatcher [
	innerMatcher := aMatcher
]

{ #category : #matching }
MatcherNAC >> match: aValue withContext: aContext [

	| contexts |
	contexts := innerMatcher match: aValue withContext: aContext.
	contexts := contexts collect: [ :ctx | 
		            ctx isMatch: ctx isMatch not.
		            ctx ].
	^ contexts
]
