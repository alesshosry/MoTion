Class {
	#name : #MatcherComplexTests,
	#superclass : #MatcherTests,
	#category : #'MoTion-Tests-matchers'
}

{ #category : #tests }
MatcherComplexTests >> testCollectSavedMatchers [

	"Here we are collecting saved Matchers from defined matcher to retrieve selectors #ifTrue:ifFalse from package MoTion"

	| matcher collectedBindingsForPackage collectedBindingsForMethod collectedBindingsForNode|
	
	 matcher := RPackage % {
		#name -> #MoTion.
		#'definedClasses>methodDict' -> CompiledMethod % { 
			#'ast>allChildren' ->  RBMessageNode % { 
					#'selector>value' -> #ifTrue:ifFalse:
			} as: #Node
		} as: #Method.
	} as: #Package.

	collectedBindingsForNode  := matcher collectBindings: {#Node} for: (#MoTion asPackage).
	collectedBindingsForMethod := matcher collectBindings: {#Method} for: (#MoTion asPackage).
	collectedBindingsForPackage  := matcher collectBindings: {#Package} for: (#MoTion asPackage).

	"collectedBindingsForNode should be bigger or equal to collectedBindingsForMethod bcz multiple nodes could be found in one method.
	 collectedBindingsForMethod should be bigger or equal to collectedBindingsForPackage bcz multiple methods could be found in one package."
	
	self assert: collectedBindingsForNode size >= collectedBindingsForMethod size.
	self assert: collectedBindingsForMethod size >= collectedBindingsForPackage size.
	

]

{ #category : #tests }
MatcherComplexTests >> testToCheckIfSelectorExistsInMethod [

	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists in AST childrens of MTDirectChildrenPath method resolveFrom:"
	| matcher|
	
	matcher := RBMethodNode % { 
		#'children*' -> RBMessageNode % { 
			#'selector>value' -> #ifTrue:ifFalse:
		}
	}.

	self assert: 
		(matcher match: (MTDirectChildrenPath>>#resolveFrom:) ast) isMatch.
	

]

{ #category : #tests }
MatcherComplexTests >> testToCheckIfSelectorExistsInMethodAST [

	| matcher|
	
	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists in AST childrens of MTDirectChildrenPath in any method"
	
	matcher := Class %% { 
		#'methodDict>ast' -> RBMethodNode % { 
			#'children*' -> RBMessageNode % { 
				#'selector>value' -> #ifTrue:ifFalse:
			}
		}
	}.

	self assert: 
		(matcher match: MTDirectChildrenPath) isMatch.
	

]

{ #category : #tests }
MatcherComplexTests >> testToCheckIfSelectorExistsInPackage [

	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists in AST childrens of all methods of all classes in package MoTion"

	| matcher|
	
	matcher := RPackage % {
		#'definedClasses>@' -> Class %% { 
			#'methodDictionary>ast' -> RBMethodNode % { 
				#'children*' -> RBMessageNode % { 
					#'selector>value' -> #ifTrue:ifFalse:
				}
			} as: #Method
		}
	}.

	self assert: 
		(matcher match: (#MoTion asPackage)) isMatch.
	

]

{ #category : #tests }
MatcherComplexTests >> testToCheckIfSelectorExistsInPackageDefinedWithComposedPath [

	"Here we are trying to check if selector '#ifTrue:ifFalse:' exists in AST childrens of all methods of all classes in package MoTion, by using ComposedPath while defining the matcher"

	| matcher|
	
	matcher := RPackage % {
	#'definedClasses>methodDict>ast>allChildren' -> RBMessageNode % { 
			#'selector>value' -> #ifTrue:ifFalse:
		}
	}.

	self assert: 
		(matcher match: (#MoTion asPackage)) isMatch.
	

]
