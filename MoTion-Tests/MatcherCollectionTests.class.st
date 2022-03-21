Class {
	#name : #MatcherCollectionTests,
	#superclass : #MatcherTests,
	#category : #'MoTion-Tests-matchers'
}

{ #category : #tests }
MatcherCollectionTests >> testToCheckDedicatedArgumentsAndReceiver [

	| matcher expression |
	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists with dedicated arguments and receiver"
	expression := RBParser parseExpression: 'self ifTrue: [1] ifFalse: 2'.
	matcher := RBMessageNode % { 
		           (#'receiver>name' -> #self).
		           (#'selector>value' -> #'ifTrue:ifFalse').
		           (#arguments -> { 
			            (RBBlockNode
			             %
			             { (#statements -> RBLiteralNode % { (#value -> 1) }) }). "first argument"
			            #'@something' }) "second argument" }.

	self assert: (matcher match: expression) isMatch.
	"The expression is correct as we defined correctly the structure of the matcher, and at the end we precised that we want value 1 inside the blockNode followed by anything. "
	
	self
		assertCollection:
		(matcher collectBinding: #something for: expression)
		hasSameElements: { (RBLiteralNode value: 2) }
		
	"Here we are checking if @something could match with 2"
]

{ #category : #tests }
MatcherCollectionTests >> testToCheckDedicatedArgumentsAndReceiverAreNotMatching [

	| matcher expression |
	"Here we defined a matcher that is missing a variableNode inside #ifTrue:ifFalse: selector, which is why it is not matching. We should say at least that arguments contain something else or we could be more specific by defining the exact valueas it is in the expression."
	expression := RBParser parseExpression: 'self ifTrue: [1] ifFalse: 2'.

	matcher := RBMessageNode % { 
		           (#'receiver>name' -> #self).
		           (#'selector>value' -> #'ifTrue:ifFalse').
		           (#arguments
		            -> { (RBBlockNode % { (#'statements>value' -> 1) }) }) }.

	self assert: (matcher match: expression) isMatch not
]

{ #category : #tests }
MatcherCollectionTests >> testToCheckDedicatedArgumentsAndReceiverWithDirectPath [

	| matcher expression |
	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists with dedicated arguments and receiver; But instead of specifying that RBBlockNode  should have the first value 1, it could match if ifFalse also has a block of 1.  "
	expression := RBParser parseExpression: 'self ifTrue: [1] ifFalse: 2'.

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
		hasSameElements: { (RBLiteralNode value: 2) }
]
