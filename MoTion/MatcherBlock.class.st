Class {
	#name : #MatcherBlock,
	#superclass : #Matcher,
	#instVars : [
		'block'
	],
	#category : #'MoTion-matcher'
}

{ #category : #'instance creation' }
MatcherBlock class >> of: aBlock [

	^ self new
		  block: aBlock;
		  yourself
]

{ #category : #accessing }
MatcherBlock >> block: aBlock [

	block := aBlock
]

{ #category : #accessing }
MatcherBlock >> isBlockMatcher [

	^ true
]

{ #category : #accessing }
MatcherBlock >> match: anObject withContext: aContext [

	| result args |
	args := block argumentNames collect: [ :name | 
		        aContext bindings at: name ].
	result := block valueWithArguments: args asArray.
	^ result asMatcher match: anObject withContext: aContext
]
