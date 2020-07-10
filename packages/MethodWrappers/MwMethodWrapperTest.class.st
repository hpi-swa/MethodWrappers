Class {
	#name : #MwMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers-Tests'
}

{ #category : #running }
MwMethodWrapperTest >> testCanWrapInClass [

	"Method wrappers can NOT be wrapped."
	self deny: (self wrapperClass canWrap: #spunk inClass: self wrapperClass).

	"BlockClosure>>ensure: can NOT be wrapped."
	self deny: (self wrapperClass canWrap: #ensure: inClass: BlockClosure).

	"CompiledMethod>>valueWithReceiver:arguments: can NOT be wrapped."
	self deny: (self wrapperClass
		canWrap: #valueWithReceiver:arguments: inClass: CompiledMethod).

	"A method that is not implemented by a class/object can NOT be wrapped."
	self assert: ((Object canUnderstand: #ensure:) not
		and: [(self wrapperClass canWrap: #ensure: inClass: Object) not]).

	"Certain primitives may NOT be wrapped."
	self assert: ((Object includesSelector: #at:put:)
		and: [(self wrapperClass canWrap: #at:put: inClass: Object) not]).
	self assert: ((BlockClosure includesSelector: #value)
		and: [(self wrapperClass canWrap: #value inClass: BlockClosure) not]).
]

{ #category : #running }
MwMethodWrapperTest >> testChainRemoveLastFirst [

	| wrapperOne wrapperTwo |
	wrapperOne := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapperTwo := self wrapperClass on: #methodOne inClass: MwClassA.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapperOne install.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	wrapperTwo install.
	self assert: wrapperOne wrappingWrapper == wrapperTwo.
	self assert: wrapperTwo wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod == wrapperOne.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperTwo uninstall.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	self assert: wrapperTwo clientMethod == nil.
	wrapperOne uninstall.
	self assert: wrapperOne clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
]

{ #category : #running }
MwMethodWrapperTest >> testChainRemoveLastFirstHierarchy [
	| wrapperOne wrapperTwo |
	wrapperOne := self wrapperClass 
		on: #methodOne
		inClass: MwClassA.
	wrapperTwo := self wrapperClass 
		on: #methodOne
		inClass: MwClassB.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapperOne install.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	wrapperTwo install.
	self assert: wrapperOne wrappingWrapper == wrapperTwo.
	self assert: wrapperTwo wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod == wrapperOne.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	self assert: (MwClassB compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperTwo uninstall.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: wrapperTwo clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	self assert: (MwClassB 
			compiledMethodAt: #methodOne
			ifAbsent: [ nil ]) == nil.
	wrapperOne uninstall.
	self assert: wrapperOne clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod
]

{ #category : #running }
MwMethodWrapperTest >> testChainRemoveMiddleFirst [

	| wrapperOne wrapperTwo |
	wrapperOne := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapperTwo := self wrapperClass on: #methodOne inClass: MwClassA.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapperOne install.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	wrapperTwo install.
	self assert: wrapperOne wrappingWrapper == wrapperTwo.
	self assert: wrapperTwo wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod == wrapperOne.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperOne uninstall.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperTwo.
	self assert: wrapperOne clientMethod == nil.
	wrapperTwo uninstall.
	self assert: wrapperTwo clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
]

{ #category : #running }
MwMethodWrapperTest >> testChainRemoveMiddleFirstHierarchy [
	| wrapperOne wrapperTwo |
	wrapperOne := self wrapperClass 
		on: #methodOne
		inClass: MwClassA.
	wrapperTwo := self wrapperClass 
		on: #methodOne
		inClass: MwClassB.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapperOne install.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	wrapperTwo install.
	self assert: wrapperOne wrappingWrapper == wrapperTwo.
	self assert: wrapperTwo wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod == wrapperOne.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	self assert: (MwClassB compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperOne uninstall.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod == nil.
	self assert: wrapperTwo clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	self assert: (MwClassB compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperTwo uninstall.
	self assert: wrapperTwo clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	self assert: (MwClassB 
			compiledMethodAt: #methodOne
			ifAbsent: [ nil ]) == nil
]

{ #category : #running }
MwMethodWrapperTest >> testCodeString0 [

	| expected actual |
	expected := 'value
	| t |
	t := #Array new.
	^ #''The method wrapper should be inserted in this position!'' valueWithReceiver: self arguments: t'.
	actual := self wrapperClass codeStringFor: 0.
	self assert: expected = actual.
]

{ #category : #running }
MwMethodWrapperTest >> testCodeString1 [

	| expected actual |
	expected := 'value: t1
	| t |
	(t := #Array new: 1) at: 1 put: t1.
	^ #''The method wrapper should be inserted in this position!'' valueWithReceiver: self arguments: t'.
	actual := self wrapperClass codeStringFor: 1.
	self assert: expected = actual.
]

{ #category : #running }
MwMethodWrapperTest >> testCodeString2 [

	| expected actual |
	expected := 'value: t1 value: t2
	| t |
	(t := #Array new: 2) at: 1 put: t1; at: 2 put: t2.
	^ #''The method wrapper should be inserted in this position!'' valueWithReceiver: self arguments: t'.
	actual := self wrapperClass codeStringFor: 2.
	self assert: expected = actual.
]

{ #category : #running }
MwMethodWrapperTest >> testDefiningWrappedDifferent [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodOne.
	wrappedClass := MwClassB.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == MwClassA.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #running }
MwMethodWrapperTest >> testDefiningWrappedSame [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodOne.
	wrappedClass := MwClassA.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == wrappedClass.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #running }
MwMethodWrapperTest >> testDefiningWrappedSame2 [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodTwo.
	wrappedClass := MwClassA.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == wrappedClass.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #running }
MwMethodWrapperTest >> testDefiningWrappedSame3 [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodTwo.
	wrappedClass := MwClassB.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == wrappedClass.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #running }
MwMethodWrapperTest >> testDefiningWrappedSame4 [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodThree.
	wrappedClass := MwClassB.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == wrappedClass.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #running }
MwMethodWrapperTest >> testInstallInstantiateUninstall [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	instance methodOne.
	wrapper uninstall.
	instance methodOne.
]

{ #category : #running }
MwMethodWrapperTest >> testInstallUninstall [

	| wrapper |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapper install.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == self wrapperClass.
	wrapper uninstall.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
]

{ #category : #running }
MwMethodWrapperTest >> testInstantiateInstallUninstall [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	instance := MwClassA new.
	instance methodOne.
	wrapper install.
	instance methodOne.
	wrapper uninstall.
	instance methodOne.
]

{ #category : #running }
MwMethodWrapperTest >> testOnInClass [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodOne.
	wrappedClass := MwClassA.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	self assert: wrapper clientSelector == clientSelector.
	self assert: wrapper clientMethod == nil.
	self assert: wrapper definingClass == nil.
	self assert: wrapper wrappedClass == wrappedClass.
	self assert: wrapper wrappingWrapper == nil.
	wrapper uninstall.
]

{ #category : #running }
MwMethodWrapperTest >> testProperties [
	| wrapper |
	wrapper := self wrapperClass new..
	self assert: wrapper clientSelector == nil.
	self assert: wrapper clientMethod == nil.
	self assert: wrapper definingClass == nil.
	self assert: wrapper wrappedClass == nil.
	self assert: wrapper wrappingWrapper == nil
]

{ #category : #running }
MwMethodWrapperTest >> testWasActive [

	| wrapper |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	self deny: wrapper wasActive.
	wrapper install.
	self deny: wrapper wasActive.
	wrapper uninstall.
	self assert: wrapper wasActive.
	self
		should: [wrapper install]
		raise: Error.
]

{ #category : #running }
MwMethodWrapperTest >> testWrapShared [
	"Wrap a method in a subclass that does not re-implement this method. The wrapper resides in the subclass only."

	| m binding wrapper transientClass |
	m := MwClassA >> #methodOne.
	"Repair MwClassA for failed runs first."
	MwClassA
		compile: m getSource asString
		classified: 'debugging'. "Cannot access organization in case of a failure because we cannot access the class and thus not the organization. Hard-coded only."
	
	binding := Smalltalk globals bindingOf: #MwClassA.
	transientClass := m methodClass subclass: #MwClassATransient
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''
		category: 'Temporary'.
	wrapper := self wrapperClass on: #methodOne inClass: transientClass.

	self assert: m literals last == binding.

	wrapper install.
	self assert: m literals last == binding.
	self assert: m methodClass notNil.
	
	wrapper uninstall.
	self assert: m literals last == binding.
	self assert: m methodClass notNil.
	
	transientClass removeFromSystem.

	self flag: #broken. "mt: Cannot reproduce the bug because garbage collection cannot be reproduced appropriately."
	"Smalltalk garbageCollect. Processor yield."
	self assert: m literals last == binding.
	self assert: m methodClass notNil.
]

{ #category : #private }
MwMethodWrapperTest >> wrapperClass [

	^ MwMethodWrapper
]
