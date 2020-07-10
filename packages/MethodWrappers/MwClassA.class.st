"
Instance Variables:

	x	<Integer>
"
Class {
	#name : #MwClassA,
	#superclass : #Object,
	#instVars : [
		'x'
	],
	#category : #'MethodWrappers-Tests'
}

{ #category : #debugging }
MwClassA >> methodDelay [

	(Delay forMilliseconds: 1) wait.
]

{ #category : #debugging }
MwClassA >> methodOne [

	"Transcript cr; show: 'MwClassA>>methodOne'."
]

{ #category : #debugging }
MwClassA >> methodTwo [

	"Transcript cr; show: 'MwClassA>>methodTwo'."
]

{ #category : #debugging }
MwClassA >> methodWithArgument: anInteger [

	self x: self x + anInteger.
	^ self x
]

{ #category : #debugging }
MwClassA >> methodWithException [

	Warning new  signal: 'Ouch'.
]

{ #category : #debugging }
MwClassA >> methodWithoutException [

	^ 69
]

{ #category : #accessing }
MwClassA >> x [
	"^ <Integer>"

	^ x
]

{ #category : #accessing }
MwClassA >> x: anInteger [

	x := anInteger.
]
