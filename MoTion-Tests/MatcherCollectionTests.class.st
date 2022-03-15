Class {
	#name : #MatcherCollectionTests,
	#superclass : #MatcherTests,
	#category : #'MoTion-Tests-matchers'
}

{ #category : #tests }
MatcherCollectionTests >> testToCheckIfSelectorExistsInMethodAST [

	| matcher expression |
	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists with dedicated arguments and receiver"
	expression := RBParser parseExpression: 'self ifTrue: [1] ifFalse: 2'.
	matcher := RBMessageNode % { 
		           (#'receiver>name' -> #self).
		           (#'selector>value' -> #'ifTrue:ifFalse').
		           (#arguments -> { 
			            (RBBlockNode % { (#statements -> RBLiteralNode % { (#value -> 1) }) }).   "first argument"
			            #'@something' })    "second argument"
	}. 

	self assert: (matcher match: expression) isMatch.
	self
		assertCollection:
		(matcher collectBinding: #something for: expression)
		hasSameElements: { (RBLiteralNode value: 2) }.


	matcher := RBMessageNode % { 
		           (#'receiver>name' -> #self).
		           (#'selector>value' -> #'ifTrue:ifFalse').
		           (#arguments -> { 
			            (RBBlockNode % { (#'statements>value' -> 1) }).
			            #'@something' }) }.

	self assert: (matcher match: expression) isMatch.
	self
		assertCollection:
		(matcher collectBinding: #something for: expression)
		hasSameElements: { (RBLiteralNode value: 2) }.
		
	
	matcher := RBMessageNode % { 
		           #'receiver>name' -> #self.
		           #'selector>value' -> #'ifTrue:ifFalse'.
		           #arguments -> { 
			            (RBBlockNode % { (#'statements>value' -> 1) })
						} 
	}.

	self assert: (matcher match: expression) isMatch not.
	
]
