Class {
	#name : #MwCountMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers-Tests'
}

{ #category : #running }
MwCountMethodWrapperTest >> testCounts [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper count = 0.
	instance methodOne.
	self assert: wrapper count = 1.
	instance methodOne.
	self assert: wrapper count = 2.
	wrapper uninstall.
]

{ #category : #private }
MwCountMethodWrapperTest >> wrapperClass [

	^ MwCountMethodWrapper
]
