running
testWrapShared
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