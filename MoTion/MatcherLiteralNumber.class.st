Class {
	#name : #MatcherLiteralNumber,
	#superclass : #MatcherLiteral,
	#category : #'MoTion-matcher'
}

{ #category : #accessing }
MatcherLiteralNumber >> match: aNewValue withContext: aContext [
	 		
	
   aNewValue isNumber 
		ifTrue: [ self matchOnlyNumber: aNewValue withContext: aContext]
		ifFalse: [
				(aNewValue isCollection and:[(aNewValue  isNotNil)])
					ifTrue: [self matchCollectionOfNumbers: aNewValue withContext: aContext] 
					ifFalse: [ aContext isMatch: false ]
			].
	 	
	^ { aContext }
]

{ #category : #'as yet unclassified' }
MatcherLiteralNumber >> matchCollectionOfNumbers: aCollectionOfLiterals withContext: aContext [


	aCollectionOfLiterals do: [ :each | 
			each isNumber 
				ifTrue:[self matchOnlyNumber: each withContext: aContext ]	
		 ].	
]

{ #category : #'as yet unclassified' }
MatcherLiteralNumber >> matchOnlyNumber: aNumber withContext: aContext [
	aNumber = value ifTrue: [ aContext isMatch: true ].
]
