Class {
	#name : #LogicalMatcherTest,
	#superclass : #MatcherTests,
	#category : #'MoTion-Tests-matchers'
}

{ #category : #tests }
LogicalMatcherTest >> testOrMatcherForComplexObjects [

	| obj matcher |
	matcher := MTTestObjectA % { (#lint -> 5) } orMatches:
		           MTTestObjectB % { (#lint -> #foo) }.

	obj := MTTestObjectA new.
	obj lint: 5.
	self assert: (matcher match: obj) isMatch.

	obj := MTTestObjectB new.
	obj lint: #foo.
	self assert: (matcher match: obj) isMatch.

	obj := MTTestObjectA new.
	obj lint: 43.
	self assert: (matcher match: obj) isMatch not
]

{ #category : #tests }
LogicalMatcherTest >> testOrMatcherForInteger [

	| obj matcher |
	matcher := MTTestObjectA % { (#lint -> (5 orMatches: 42)) }.

	obj := MTTestObjectA new.
	obj lint: 5.
	self assert: (matcher match: obj) isMatch.

	obj := MTTestObjectA new.
	obj lint: 42.
	self assert: (matcher match: obj) isMatch.

	obj := MTTestObjectA new.
	obj lint: 43.
	self assert: (matcher match: obj) isMatch not
]

{ #category : #tests }
LogicalMatcherTest >> testOrMatcherForMixedType [

	| obj matcher |
	matcher := MTTestObjectA % { (#lint -> (5 orMatches: #foo)) }.

	obj := MTTestObjectA new.
	obj lint: 5.
	self assert: (matcher match: obj) isMatch.

	obj := MTTestObjectA new.
	obj lint: #foo.
	self assert: (matcher match: obj) isMatch.

	obj := MTTestObjectA new.
	obj lint: 43.
	self assert: (matcher match: obj) isMatch not
]
