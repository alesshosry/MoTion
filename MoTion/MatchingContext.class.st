Class {
	#name : #MatchingContext,
	#superclass : #Object,
	#instVars : [
		'bindings',
		'isMatch'
	],
	#category : #'MoTion-matcher'
}

{ #category : #accessing }
MatchingContext >> atBindingKey: aKey put: aValue [
	 
	self bindings at: aKey put: aValue.
	
	"Since the MatchingContext can be used in different places (same function can have input and output the Matching Context), we leave the isMatch to be filled in the Matcher code, more specifically in the match and match:withCOntext methods."
]

{ #category : #accessing }
MatchingContext >> bindings [

	^ bindings
]

{ #category : #initialization }
MatchingContext >> initialize [ 
	super initialize.
	bindings := Dictionary new.
	isMatch := false.
]

{ #category : #accessing }
MatchingContext >> isMatch [

	^ isMatch
]

{ #category : #accessing }
MatchingContext >> isMatch: aBoolean [

	isMatch := aBoolean
]
