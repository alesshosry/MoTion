Class {
	#name : #BaselineOfMotion,
	#superclass : #BaselineOf,
	#category : #BaselineOfMoTion
}

{ #category : #baselines }
BaselineOfMotion >> baseline: spec [
   <baseline>
	spec for: #'common' do: [
		spec 
			package: #'MoTion';
			package: #'MoTion-Tests' with: [
				spec requires: #('MoTion' ) ].
		spec 
			group: 'default' with: #('MoTion' 'MoTion-Tests') ]
]
