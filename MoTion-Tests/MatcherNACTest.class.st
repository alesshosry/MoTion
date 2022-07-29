Class {
	#name : #MatcherNACTest,
	#superclass : #MatcherTests,
	#category : #'MoTion-Tests-matchers'
}

{ #category : #tests }
MatcherNACTest >> testNACCreation [

	| not1 |
	not1 := 1 asMatcher not.

	self assert: (not1 match: 'r') isMatch.
	self assert: (not1 match: 4) isMatch.
	self deny: (not1 match: 1) isMatch
]

{ #category : #tests }
MatcherNACTest >> testNACCreationOnObjectMatcher [

	| matcher a |
	matcher := MTTestObjectA % { (#lint <~=> Number %% {  }) }.

	a := MTTestObjectA new.
	a lint: 'r'.

	self assert: (matcher match: a) isMatch.

	a lint: 5.
	self deny: (matcher match: a) isMatch
]

{ #category : #tests }
MatcherNACTest >> testNACOnDeepPattern [

	| matcher a b |
	matcher := MTTestObjectA
	           % { (#lint <~=> MTTestObjectB %% { (#lint <=> 5) }) }.

	a := MTTestObjectA new.
	b := MTTestObjectB new.
	a lint: b.
	b lint: 10.

	self assert: (matcher match: a) isMatch.

	b lint: 5.
	self deny: (matcher match: a) isMatch
]

{ #category : #tests }
MatcherNACTest >> testNACOnType [

	| notANumber |
	notANumber := (Number %% {  }) not.

	self assert: (notANumber match: 'r') isMatch.
	self assert: (notANumber match: #a) isMatch.
	self deny: (notANumber match: 34) isMatch.
	self deny: (notANumber match: 3.42) isMatch
]
