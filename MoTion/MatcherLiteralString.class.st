Class {
	#name : #MatcherLiteralString,
	#superclass : #MatcherLiteral,
	#category : #'MoTion-matcher'
}

{ #category : #accessing }
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

{ #category : #accessing }
MatcherLiteralString >> matchCollectionOfStrings: aCollectionOfLiterals withContext: aContext [
 
		 
		aCollectionOfLiterals do: [ :each | 
			each isString 
				ifTrue:[ self matchOnlyString: each withContext: aContext  ]
				"ifFalse: [ here we have to check if it is symbol like #name .... for the customStringMatcher]"	
		 ].	
]

{ #category : #accessing }
MatcherLiteralString >> matchOnlyString: aString withContext: aContext [
	
	"so here we are matching either fully or at least the string exist in the chain. "
	
	|sizeFound|
	sizeFound :=  aString asString findString: value.
	
	value = aString | ((aString asString findString: value) > 0)  
		ifTrue: [ aContext  isMatch: true ].
	
	 
]
