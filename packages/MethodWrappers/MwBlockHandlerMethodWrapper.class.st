"
Inherited Class Instance Variables:

	wrapperInstVars	<WeakIdentityKeyDictionary
								key: MwBlockHandlerMethodWrapper
								value: MwBlockHandlerMethodWrapperInstVars>
							A kludge to add instance varibles to non-pointer classes.
"
Class {
	#name : #MwBlockHandlerMethodWrapper,
	#superclass : #MwMethodWrapper,
	#instVars : [
		'exception',
		'handlerBlock'
	],
	#category : #'MethodWrappers-Base'
}

{ #category : #evaluating }
MwBlockHandlerMethodWrapper >> afterMethod [

	self shouldNotImplement.
]

{ #category : #evaluating }
MwBlockHandlerMethodWrapper >> beforeMethod [

	self shouldNotImplement.
]

{ #category : #initialization }
MwBlockHandlerMethodWrapper >> class: aClass selector: aSymbol [

	super class: aClass selector: aSymbol.
	self
		exception: Error;
		handlerBlock: [:receiver :arguments :ex | ].
]

{ #category : #'derived accessing' }
MwBlockHandlerMethodWrapper >> exception [
	^ exception
]

{ #category : #'derived accessing' }
MwBlockHandlerMethodWrapper >> exception: anExceptionClass [
	exception :=  anExceptionClass
]

{ #category : #'derived accessing' }
MwBlockHandlerMethodWrapper >> handlerBlock [
	^ handlerBlock 
]

{ #category : #'derived accessing' }
MwBlockHandlerMethodWrapper >> handlerBlock: aBlockContext [
	handlerBlock := aBlockContext fixTemps.
]

{ #category : #installation }
MwBlockHandlerMethodWrapper >> uninstall [

	self handlerBlock ifNotNilDo: [:block | block instVarNamed: 'outerContext' put: nil].
	self flag: #rhi. "self handlerBlock: nil."
	super uninstall.
]

{ #category : #evaluating }
MwBlockHandlerMethodWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [

	^ [
		self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects.
	] on: self exception do: [:ex |
		self handlerBlock copy fixTemps value: anObject value: anArrayOfObjects value: ex]
]
