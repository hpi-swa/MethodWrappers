Class {
	#name : #MwClosestInstallationsTests,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers-Tests'
}

{ #category : #'as yet unclassified' }
MwClosestInstallationsTests >> testConflictDetection [
	| wrapperOne wrapperTwo aClass aSelector |
	aClass := MwClassA.
	aSelector := #methodOne.	

	wrapperOne := self wrapperClass on: aSelector inClass: aClass.
	wrapperTwo := self wrapperClass on: aSelector inClass: aClass.
	
	wrapperOne installClosestToMethod.
	self should: [ wrapperTwo installClosestToMethod ] raise: AssertionFailure.
	
	wrapperTwo uninstall.
	wrapperOne uninstall.
]

{ #category : #'as yet unclassified' }
MwClosestInstallationsTests >> testInstallClosestToMethod [
	| current wrapperOne wrapperTwo aClass aSelector |
	aClass := MwClassA.
	aSelector := #methodOne.
	current := aClass compiledMethodAt: aSelector.
	
	wrapperOne := self wrapperClass on: aSelector inClass: aClass.
	wrapperTwo := self wrapperClass on: aSelector inClass: aClass.
	
	wrapperOne install.
	wrapperTwo installClosestToMethod.
	
	self deny: [ wrapperTwo clientMethod isMwMethodWrapper ].
	
	current isMwMethodWrapper
		ifTrue: [ 
			self assert: [ current clientMethod == wrapperTwo ].
			self assert: [ wrapperOne clientMethod == current ] ]
		ifFalse: [
			self assert: [ wrapperTwo clientMethod == current ].
			self assert: [ wrapperOne clientMethod == wrapperTwo ] ].
	
	wrapperTwo uninstall.
	wrapperOne uninstall.
]

{ #category : #'as yet unclassified' }
MwClosestInstallationsTests >> wrapperClass [

	^ MwMethodWrapper
]
