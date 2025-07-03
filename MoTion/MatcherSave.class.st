Class {
	#name : 'MatcherSave',
	#superclass : 'Matcher',
	#instVars : [
		'alias',
		'matcher'
	],
	#category : 'MoTion-matcher',
	#package : 'MoTion',
	#tag : 'matcher'
}

{ #category : 'instance creation' }
MatcherSave class >> of: aMatcher withAlias: aSymbol [

	^ self new
		  matcher: aMatcher;
		  alias: aSymbol;
		  yourself
]

{ #category : 'accessing' }
MatcherSave >> alias: aSymbol [

	alias := aSymbol
]

{ #category : 'accessing' }
MatcherSave >> match: anObject withContext: aContext [

	aContext atBindingKey: alias put: anObject.
	^ matcher match: anObject withContext: aContext
]

{ #category : 'accessing' }
MatcherSave >> matcher: aMatcher [

	matcher := aMatcher
]
