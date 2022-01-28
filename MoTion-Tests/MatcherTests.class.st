Class {
	#name : #MatcherTests,
	#superclass : #TestCase,
	#category : #'MoTion-Tests-matchers'
}

{ #category : #tests }
MatcherTests >> testMatcherNumber [
	| myMatcher |
	myMatcher := MatcherLiteralNumber  new.
	myMatcher value: 100.
	 
	self assert: (myMatcher match: 100) isMatch.
	self deny: (myMatcher match: 900) isMatch 
]

{ #category : #tests }
MatcherTests >> testMatcherNumberCollection [
	| myMatcher |
	myMatcher := MatcherLiteralNumber of: 100.
	 
	self assert: (myMatcher match: {100. 200. 300 }) isMatch.
	self deny: (myMatcher match: 900) isMatch 
]

{ #category : #tests }
MatcherTests >> testMatcherStringCollection [
	
	| myMatcher |
	myMatcher := MatcherLiteralString of: 'Hello'.
	 
	self assert: (myMatcher match: {'Hello World'. 'We are trying to'. 'test a collection' }) isMatch.
	self assert: (myMatcher match: {'Hello'. 'Here we are using only hello'. 'test a collection' }) isMatch.
	self deny: (myMatcher match: 'Hi Mr. hello') isMatch 
]

{ #category : #tests }
MatcherTests >> testMatcherStringFull [
	
	| myMatcher |
	myMatcher := MatcherLiteralString new.
	myMatcher value: 'Hello'.
	 
	self assert: (myMatcher match: 'Hello') isMatch.
	self deny: (myMatcher match: 'Hi') isMatch 
]

{ #category : #tests }
MatcherTests >> testMatcherStringPartial [
	
	| myMatcher |
	myMatcher := MatcherLiteralString new.
	myMatcher value: 'Hello'.
	 
	self assert: (myMatcher match: 'Hello World') isMatch.
	self deny: (myMatcher match: 'Hi Mr.') isMatch 
]
