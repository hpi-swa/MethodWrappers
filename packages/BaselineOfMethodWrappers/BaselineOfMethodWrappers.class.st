Class {
	#name : #BaselineOfMethodWrappers,
	#superclass : #BaselineOf,
	#category : #BaselineOfMethodWrappers
}

{ #category : #baseline }
BaselineOfMethodWrappers >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec package: 'MethodWrappers' with: [ ].
				
		spec
			group: 'default' with: #('MethodWrappers')].

]
