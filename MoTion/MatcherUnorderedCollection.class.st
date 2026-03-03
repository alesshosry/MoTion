Class {
	#name : 'MatcherUnorderedCollection',
	#superclass : 'Matcher',
	#instVars : [
		'matcherSequence'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherUnorderedCollection class >> of: aMatcherSequence [
	^ self new matcherSequence: aMatcherSequence; yourself
]

{ #category : 'accessing' }
MatcherUnorderedCollection >> matcherSequence [

	^ matcherSequence
]

{ #category : 'accessing' }
MatcherUnorderedCollection >> matcherSequence: anObject [

	matcherSequence := anObject
]
