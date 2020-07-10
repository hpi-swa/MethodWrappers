Class {
	#name : #MwTestCase,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : #'MethodWrappers-Tests'
}

{ #category : #testing }
MwTestCase class >> isAbstract [

	^ self == MwTestCase
]

{ #category : #accessing }
MwTestCase >> result [
	"^ <Integer>"

	^ result
]

{ #category : #accessing }
MwTestCase >> result: anInteger [

	result := anInteger.
]
