Class {
	#name : #MwBlockHandlerMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers-Tests'
}

{ #category : #running }
MwBlockHandlerMethodWrapperTest >> setUp [

	self result: 0.
]

{ #category : #running }
MwBlockHandlerMethodWrapperTest >> testException [

	| wrapper instance |
	instance := MwClassA new.
	self should: [self result: instance methodWithException] raise: Warning.
	self assert: self result = 0.
	wrapper := self wrapperClass on: #methodWithException inClass: MwClassA.
	wrapper
		exception: Warning;
		handlerBlock: [:receiver :arguments :ex | 42];
		install.
	self shouldnt: [self result: instance methodWithException] raise: Warning.
	wrapper uninstall.
	self assert: self result = 42.
]

{ #category : #running }
MwBlockHandlerMethodWrapperTest >> testInstallUninstall [

	| wrapper |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapper install.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == self wrapperClass.
	wrapper uninstall.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
]

{ #category : #running }
MwBlockHandlerMethodWrapperTest >> testNoException [

	| wrapper instance |
	instance := MwClassA new.
	self shouldnt: [self result: instance methodWithoutException] raise: Warning.
	self assert: self result = 69.
	wrapper := self wrapperClass on: #methodWithoutException inClass: MwClassA.
	wrapper
		exception: Warning;
		handlerBlock: [:receiver :arguments :ex | 42];
		install.
	self shouldnt: [self result: instance methodWithoutException] raise: Warning.
	wrapper uninstall.
	self assert: self result = 69.
]

{ #category : #running }
MwBlockHandlerMethodWrapperTest >> testOtherException [

	| wrapper instance |
	instance := MwClassA new.
	self should: [instance methodWithException] raise: Warning.
	self assert: self result = 0.
	wrapper := self wrapperClass on: #methodWithException inClass: MwClassA.
	wrapper
		exception: Error;
		handlerBlock: [:receiver :arguments :ex | 42];
		install.
	self should: [self result: instance methodWithException] raise: Warning.
	wrapper uninstall.
	self assert: self result = 0.
]

{ #category : #private }
MwBlockHandlerMethodWrapperTest >> wrapperClass [

	^ MwBlockHandlerMethodWrapper
]
