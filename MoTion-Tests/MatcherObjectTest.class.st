Class {
	#name : #MatcherObjectTest,
	#superclass : #MatcherTests,
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : #'MoTion-Tests-matchers'
}

{ #category : #running }
MatcherObjectTest >> setUp [

	super setUp.

	a := MTTestObjectA new.
	b := MTTestObjectB new.
	c := MTTestObjectC new.

	a b: b.
	a c: c.
	b c: c.
	c a: a.
	
	a lint: 15.
	b lint: 42.
	c lint: 15.
	
	a lstring: 'foo'.
	b lstring: 'bar'.
	c lstring: 'foobar'.
]

{ #category : #tests }
MatcherObjectTest >> testDirectPathLiterals [

	| matcher |
	matcher := MatcherObject type: MTTestObjectA withProperties: {  }.

	self assert: (matcher match: a) isMatch.

	matcher := MatcherObject
		           type: MTTestObjectA
		           withProperties:
		           { (#lint -> (MatcherLiteralNumber of: 15)) }.

	self assert: (matcher match: a) isMatch.

	matcher := MatcherObject type: MTTestObjectA withProperties: { 
			           (#lint -> (MatcherLiteralNumber of: 15)).
			           (#lstring -> (MatcherLiteralString of: 'foo')) }.

	self assert: (matcher match: a) isMatch.


	"These test should not match"
	matcher := MatcherObject type: MTTestObjectA withProperties: { 
			           (#lint -> (MatcherLiteralNumber of: 15)).
			           (#lstring -> (MatcherLiteralString of: 'foobar')) }.

	self deny: (matcher match: a) isMatch.

	matcher := MatcherObject
		           type: MTTestObjectA
		           withProperties:
		           { (#lint -> (MatcherLiteralNumber of: 16)) }.

	self deny: (matcher match: a) isMatch.

	matcher := MatcherObject
		           type: MTTestObjectA
		           withProperties:
		           { (#lint -> (MatcherLiteralNumber of: 16)) }.

	self deny: (matcher match: b) isMatch
]

{ #category : #tests }
MatcherObjectTest >> testDirectPathMatcherCreation [

	| matcher |
	matcher := MTTestObjectA % {  }.
	self assert: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { (#lint -> 15) }.
	self assert: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { 
		           (#lint -> 15).
		           (#lstring -> 'foo') }.
	self assert: (matcher match: a) isMatch.


	"These test should not match"
	matcher := MTTestObjectA % { 
		           (#lint -> 15).
		           (#lstring -> 'foobar') }.
	self deny: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { (#lint -> 16) }.
	self deny: (matcher match: a) isMatch.

	matcher := MTTestObjectA % { (#lint -> 16) }.
	self deny: (matcher match: b) isMatch
]
