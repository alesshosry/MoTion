Class {
	#name : #BaselineOfMoTion,
	#superclass : #BaselineOf,
	#category : #BaselineOfMoTion
}

{ #category : #baselines }
BaselineOfMoTion >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: #MoTion;
			package: #'MoTion-Tests' with: [ spec requires: #( 'MoTion' ) ].
		spec for: #MooseX do: [ spec package: 'MoTion-Moose' ].
		spec group: 'default' with: #( 'MoTion' 'MoTion-Tests' ) ]
]
