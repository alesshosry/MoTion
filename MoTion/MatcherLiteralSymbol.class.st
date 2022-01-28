Class {
	#name : #MatcherLiteralSymbol,
	#superclass : #MatcherLiteral,
	#category : #'MoTion-matcher'
}

{ #category : #'private-running' }
MatcherLiteralSymbol >> match: aNewValue withContext: aContext [
	 		
	 
	aNewValue isString 
		ifTrue: [ self matchOnlySymbol: aNewValue withContext: aContext]
		ifFalse: [
				aNewValue isCollection & (aNewValue isNotNil) 
					ifTrue: [self matchCollectionOfSymbols: aNewValue withContext: aContext] 
					ifFalse: [ aContext isMatch: false ]
			].
	 	
	^ { aContext }
]

{ #category : #'as yet unclassified' }
MatcherLiteralSymbol >> matchCollectionOfSymbols: aCollectionOfSymbols withContext: aContext [

	aCollectionOfSymbols do: [ :each | 
		each isSymbol ifTrue: [ "ifFalse: [ here we have to check if it is symbol like #name .... for the customStringMatcher]"
			self matchOnlySymbol: each withContext: aContext.
			aContext isMatch ifTrue: [ ^ self ] ] ]
]

{ #category : #'as yet unclassified' }
MatcherLiteralSymbol >> matchOnlySymbol: aSymbol withContext: aContext [
	
	| sizeFound |
	sizeFound := aSymbol asString findString: value.

	aContext isMatch:
		(value = aSymbol or: [ (aSymbol asString findString: value) > 0 ])
]
