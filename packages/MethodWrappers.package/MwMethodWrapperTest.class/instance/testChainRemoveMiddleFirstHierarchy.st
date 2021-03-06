running
testChainRemoveMiddleFirstHierarchy
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