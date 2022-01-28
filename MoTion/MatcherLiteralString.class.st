Class {
	#name : #MatcherLiteralString,
	#superclass : #MatcherLiteral,
	#category : #'MoTion-matcher'
}

{ #category : #matching }
MatcherLiteralString >> match: aNewValue withContext: aContext [
	 		
	 
	aNewValue isString 
		ifTrue: [ self matchOnlyString: aNewValue withContext: aContext]
		ifFalse: [
				aNewValue isCollection & (aNewValue isNotNil) 
					ifTrue: [self matchCollectionOfStrings: aNewValue withContext: aContext] 
					ifFalse: [ aContext isMatch: false ]
			].
	 	
	^ { aContext }
]

{ #category : #matching }
MatcherLiteralString >> matchCollectionOfStrings: aCollectionOfLiterals withContext: aContext [

	aCollectionOfLiterals do: [ :each | 
		each isString ifTrue: [ "ifFalse: [ here we have to check if it is symbol like #name .... for the customStringMatcher]" 
			self matchOnlyString: each withContext: aContext ] ]
]

{ #category : #matching }
MatcherLiteralString >> matchOnlyString: aString withContext: aContext [

	"so here we are matching either fully or at least the string exist in the chain. "

	| sizeFound |
	sizeFound := aString asString findString: value.

	aContext isMatch:
		(value = aString or: [ (aString asString findString: value) > 0 ])
]
