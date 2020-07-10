"
Inherited Class Instance Variables:

	wrapperInstVars	<WeakIdentityKeyDictionary
								key: MwBlockMethodWrapper
								value: MwBlockMethodWrapperInstVars>
							A kludge to add instance varibles to non-pointer classes.
"
Class {
	#name : #MwBlockMethodWrapper,
	#superclass : #MwMethodWrapper,
	#instVars : [
		'beforeBlock',
		'afterBlock'
	],
	#category : #'MethodWrappers-Base'
}

{ #category : #'derived accessing' }
MwBlockMethodWrapper >> afterBlock [
	^ afterBlock
]

{ #category : #'derived accessing' }
MwBlockMethodWrapper >> afterBlock: aBlockContext [

	afterBlock := aBlockContext fixTemps.
]

{ #category : #evaluating }
MwBlockMethodWrapper >> afterMethod [

	self shouldNotImplement.
]

{ #category : #'derived accessing' }
MwBlockMethodWrapper >> beforeBlock [

	^ beforeBlock
]

{ #category : #'derived accessing' }
MwBlockMethodWrapper >> beforeBlock: aBlockContext [
	beforeBlock := aBlockContext fixTemps
]

{ #category : #evaluating }
MwBlockMethodWrapper >> beforeMethod [

	self shouldNotImplement.
]

{ #category : #initialization }
MwBlockMethodWrapper >> class: aClass selector: aSymbol [

	super class: aClass selector: aSymbol.
	self
		beforeBlock: [:receiver :arguments | ];
		afterBlock: [:receiver :arguments | ].
]

{ #category : #installation }
MwBlockMethodWrapper >> uninstall [

	self flag: #rhi. "self clientMethod ifNil: [^ self]."
	self beforeBlock ifNotNilDo: [:block | block instVarNamed: 'outerContext' put: nil].
	self flag: #rhi. "self beforeBlock: nil."
	self afterBlock ifNotNilDo: [:block | block instVarNamed: 'outerContext' put: nil].
	self flag: #rhi. "self afterBlock: nil."
	super uninstall.
]

{ #category : #evaluating }
MwBlockMethodWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [
	"This is the general case where you want both a before and after block, but if you
	want just a before block, you might want to override this method for optimization."

	self beforeBlock copy fixTemps value: anObject value: anArrayOfObjects.
	^ [
		self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects.
	] ensure: [self afterBlock copy fixTemps value: anObject value: anArrayOfObjects]
]
