"
Method wrappers can add ""hidden"" behavior to the ordinary method. They can change what is executed before or after the method. For example, a count method wrapper would increment a counter when the method is called, and then forward the call onto the original method.

While this class is not abstract (i.e., there are no subclassResponsibilities), these method wrappers don't do anything if you install them. Look at the subclasses for example uses.

To create a new type of method wrapper, you must create a subclass of MwMethodWrapper and redefine the #beforeMethod and/or #afterMethod as necessary. If you only need to redefine the #beforeMethod, you can redefine the #valueFrom:arguments: method instead (see the count method wrapper). This will give you some added performance since it doesn't need to create two blocks and send the #valueNowOrOnUnwindDo: message.

To use a method wrapper, send the class a #on:inClass: message. This will return a new method wrapper (or nil if this method shouldn't be wrapped). You can then install the method wrapper by sending the #install message and uninstall by sending the #uninstall message.

WARNING: Incorrectly using the wrappers can crash your image, so you should save your image before using them. Most problems occur as a result of installing them on methods that are called either in the #beforeMethod or #afterMethod. (Note: The #value method in Association (VariableBinding in VW2.5) is automatically called by the VM when you refer to a global, class, or pool variable so you should probably never wrap it. I advise against wrapping primitives also.)

Class Instance Variables:

	protoMethods		<Dictionary
								key: SmallInteger
								value: MwMethodWrapper>
							Prototype wrappers that are copied when installing new wrappers.
	wrapperInstVars	<WeakIdentityKeyDictionary
								key: MwMethodWrapper
								value: MwMethodWrapperInstVars>
							A kludge to add instance varibles to non-pointer classes.
"
Class {
	#name : #MwMethodWrapper,
	#superclass : #Object,
	#instVars : [
		'clientMethod',
		'clientSelector',
		'definingClass',
		'wrappedClass',
		'wrappingWrapper',
		'wasActive',
		'installedClosestToMethod'
	],
	#category : #'MethodWrappers-Base'
}

{ #category : #testing }
MwMethodWrapper class >> canWrap: aSelector inClass: aClass [
	"Test if a method can be wrapped without causing infinite recursion."

	| class method |
	(aClass includesBehavior: MwMethodWrapper) ifTrue: [^ false].
	aClass isTrait ifTrue: [^ false].
	((aClass includesBehavior: CompiledMethod)
		and: [aSelector == #valueWithReceiver:arguments:])
			ifTrue: [^ false].
	((aClass includesBehavior: BlockClosure)
		and: [aSelector == #ensure: or: [aSelector == #value]])
			ifTrue: [^ false].
	class := aClass whichClassIncludesSelector: aSelector.
	class isNil ifTrue: [^ false].
	method := class compiledMethodAt: aSelector ifAbsent: [nil].
	^ method notNil and: [(self primitives includes: method primitive) not]
]

{ #category : #private }
MwMethodWrapper class >> codeStringFor: numArgs [

	| nameString tempsString |
	numArgs == 0
		ifTrue: [
			nameString := 'value'.
			tempsString := 't := #Array new']
		ifFalse: [
			nameString := ''.
			tempsString := '(t := #Array new: ', numArgs printString, ')'.
			1 to: numArgs do: [:i |
				nameString := nameString,
					'value: t',
					i printString,
					(i == numArgs ifTrue: [''] ifFalse: [' ']).
				tempsString := tempsString,
					(i == 1 ifTrue: [''] ifFalse: [';']),
					' at: ' , i printString,
					' put: t',
					i printString]].
	^ nameString, '
	| t |
	', tempsString, '.
	^ ',
	self methodWrapperSymbol printString,
	' valueWithReceiver: self arguments: t'
]

{ #category : #CHECKS }
MwMethodWrapper class >> countAllInstances [
	"doIt: [self countAllInstances]"

	| totalCount |
	totalCount := 0.
	Smalltalk garbageCollect.
	Transcript cr.
	self withAllSubclassesDo: [:each |
		| count |
		count := each allInstances size.
		totalCount := totalCount + count.
		Transcript cr; show: each name, ' -> ', count printString].
	Transcript cr; show: '=== TOTAL COUNT -> ', totalCount printString.
]

{ #category : #'class initialization' }
MwMethodWrapper class >> initializeWithAllSubclasses [
	"doIt: [self initializeWithAllSubclasses]"

	self withAllSubclassesDo: [:each | each initialize].
]

{ #category : #private }
MwMethodWrapper class >> methodWrapperSymbol [

	^ #'The method wrapper should be inserted in this position!'
]

{ #category : #private }
MwMethodWrapper class >> nuke [
	"doIt: [self nuke]"

	self
		uninstallAllWrappers;
		initialize.
]

{ #category : #'instance creation' }
MwMethodWrapper class >> on: aSymbol inClass: aClass [

	| wrapper |
	(self canWrap: aSymbol inClass: aClass) ifFalse: [^ nil].
	wrapper := self new.
	wrapper class: aClass selector: aSymbol.
	^ wrapper
]

{ #category : #private }
MwMethodWrapper class >> primitives [

	^ #(
		61		"at:put:"
		71		"new:"
		81		"value"
	)
]

{ #category : #private }
MwMethodWrapper class >> uninstallAllWrappers [
	"doIt: [self uninstallAllWrappers]"

	self allSubInstancesDo: [:inst | inst uninstall].
]

{ #category : #evaluating }
MwMethodWrapper >> afterMethod [
]

{ #category : #'as yet unclassified' }
MwMethodWrapper >> at: pc [
	^ self unwrappedMethod at: pc
]

{ #category : #evaluating }
MwMethodWrapper >> beforeMethod [
]

{ #category : #initialization }
MwMethodWrapper >> class: aClass selector: aSymbol [

	self
		wrappedClass: aClass;
		clientSelector: aSymbol.
]

{ #category : #'derived accessing' }
MwMethodWrapper >> clientMethod [

	^ clientMethod
]

{ #category : #'derived accessing' }
MwMethodWrapper >> clientMethod: aCompiledMethod [

	clientMethod := aCompiledMethod.
]

{ #category : #'derived accessing' }
MwMethodWrapper >> clientSelector [

	^ clientSelector
]

{ #category : #'derived accessing' }
MwMethodWrapper >> clientSelector: aSymbol [

	clientSelector := aSymbol
]

{ #category : #'derived accessing' }
MwMethodWrapper >> compiledMethod [
	^ self clientMethod
]

{ #category : #'derived accessing' }
MwMethodWrapper >> definingClass [

	^ definingClass
]

{ #category : #'derived accessing' }
MwMethodWrapper >> definingClass: aClass [

	definingClass := aClass.
]

{ #category : #initialization }
MwMethodWrapper >> doesNotUnderstand: aMessage [
	"required for all meta messages that need information from the original method"
	(self clientMethod isNil and: [aMessage selector == #flushCache]) ifTrue: [^ self].
	(self wrappedClass ~= self definingClass and: [aMessage selector == #methodClass:]) ifTrue: [^ self "Ignore silently. *sigh*"].
	^ aMessage sendTo: self clientMethod.
]

{ #category : #accessing }
MwMethodWrapper >> flushCache [

	"Ignore."
]

{ #category : #installation }
MwMethodWrapper >> install [

	| holdingClass method |
	self flag: #rhi. "KLUDGE: Einwegwrapper."
	self wasActive ifTrue: [self error: 'Einwegwrapper!'].
	holdingClass := self wrappedClass whichClassIncludesSelector: self clientSelector.
	holdingClass isNil ifTrue: [^ self].
	method := holdingClass compiledMethodAt: self clientSelector.
	method == self ifTrue: [^ self].
	self clientMethod: method.
	method isMwMethodWrapper
		ifTrue: [
			method wrappingWrapper: self.
			self definingClass: method definingClass]
		ifFalse: [self definingClass: holdingClass].
	self wrappedClass addSelectorSilently: self clientSelector withMethod: self.
]

{ #category : #installation }
MwMethodWrapper >> installAsLastInChain: aMethodWrapper [

	self clientMethod isMwMethodWrapper
		ifTrue: [ self clientMethod installAsLastInChain: aMethodWrapper]
		ifFalse: [ 
			self assert: [self wasInstalledClosestToMethod not] 
				description: 'there is already a wrapper installed closest to the method'.
			
			self installBeforeClientMethod: aMethodWrapper.
			aMethodWrapper markAsInstalledClosestToMethod ].
]

{ #category : #installation }
MwMethodWrapper >> installBeforeClientMethod: aMethodWrapper [
	aMethodWrapper 
		clientMethod: self clientMethod;
		setSourcePointer: self sourcePointer;
		definingClass: self definingClass;
		wrappingWrapper: self.
			
	self clientMethod: aMethodWrapper
]

{ #category : #installation }
MwMethodWrapper >> installClosestToMethod [
	| holdingClass clientMethod |
	self wasActive ifTrue: [self error: 'Einwegwrapper!'].
	holdingClass := self wrappedClass whichClassIncludesSelector: self clientSelector.
	holdingClass isNil ifTrue: [^ self].
	clientMethod := holdingClass compiledMethodAt: self clientSelector.
	clientMethod == self ifTrue: [^ self].
	
	clientMethod isMwMethodWrapper
		ifTrue: [
			clientMethod installAsLastInChain: self ]
		ifFalse: [
			self 
				definingClass: holdingClass;
				clientMethod: clientMethod;
				setSourcePointer: clientMethod sourcePointer.
		
			self wrappedClass addSelectorSilently: self clientSelector withMethod: self.
			self markAsInstalledClosestToMethod ].
]

{ #category : #testing }
MwMethodWrapper >> isInstalled [
	self definingClass ifNotNil:
		[:class|
		self clientSelector ifNotNil:
			[:selector|
			^self == (class methodDict at: selector ifAbsent: [])]].
	^false
]

{ #category : #testing }
MwMethodWrapper >> isMwMethodWrapper [

	^ true
]

{ #category : #'derived accessing' }
MwMethodWrapper >> markAsInstalledClosestToMethod [
	installedClosestToMethod := true.
]

{ #category : #private }
MwMethodWrapper >> run: aSelector with: anArrayOfObjects in: aReceiver [
	^ self valueWithReceiver: aReceiver arguments: anArrayOfObjects
]

{ #category : #installation }
MwMethodWrapper >> uninstall [

	self flag: #rhi. "The #uninstall should actually become #destroy!"
	[	self clientMethod ifNil: [^ self].
		(self wrappedClass compiledMethodAt: self clientSelector ifAbsent: [nil]) == self
			ifTrue: [self wrappedClass == self definingClass
				ifTrue: [self wrappedClass
					addSelectorSilently: self clientSelector
					withMethod: self clientMethod]
				ifFalse: [self wrappedClass removeSelectorSilently: self clientSelector]].
		self clientMethod isMwMethodWrapper
			ifTrue: [self clientMethod wrappingWrapper: self wrappingWrapper].
		self wrappingWrapper
			ifNotNil: [
				self wrappingWrapper
					clientMethod: self clientMethod;
					definingClass: self definingClass.
				self wrappingWrapper: nil].
		self
			definingClass: nil;
			clientMethod: nil.
	] ensure: [
		self flag: #rhi. "KLUDGE: Einwegwrapper."
		self wasActive: true].
]

{ #category : #'derived accessing' }
MwMethodWrapper >> unwrappedMethod [

	^ self clientMethod ifNotNil: [self clientMethod unwrappedMethod]
]

{ #category : #evaluating }
MwMethodWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [
	"This is the general case where you want both a before and after method, but if you
	want just a before method, you might want to override this method for optimization."

	self beforeMethod.
	^ [
		self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects.
	] ensure: [self afterMethod]
]

{ #category : #testing }
MwMethodWrapper >> wasActive [

	self flag: #rhi. "KLUDGE: Einwegwrapper."
	^ wasActive ifNil: [ wasActive := false ]
]

{ #category : #testing }
MwMethodWrapper >> wasActive: aBoolean [
	wasActive := aBoolean
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wasInstalledClosestToMethod [
	^ installedClosestToMethod ifNil: [ installedClosestToMethod := false ]
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wrappedClass [

	^ wrappedClass
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wrappedClass: aClass [

	wrappedClass := aClass
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wrapperInstVars [

	^ self class wrapperInstVars
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wrappingWrapper [

	^ wrappingWrapper
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wrappingWrapper: aMwMethodWrapper [

	wrappingWrapper := aMwMethodWrapper.
]
