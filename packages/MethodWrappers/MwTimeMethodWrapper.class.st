"
A time method wrapper counts the number of times the method has been called, along with the total execution time this method has taken.

Inherited Class Instance Variables:

	wrapperInstVars	<WeakIdentityKeyDictionary
								key: MwTimeMethodWrapper
								value: MwTimeMethodWrapperInstVars>
							A kludge to add instance varibles to non-pointer classes.
"
Class {
	#name : #MwTimeMethodWrapper,
	#superclass : #MwCountMethodWrapper,
	#instVars : [
		'time'
	],
	#category : #'MethodWrappers-Examples'
}

{ #category : #'class initialization' }
MwTimeMethodWrapper class >> initialize [
	"doIt: [self initialize]"

	super initialize.
]

{ #category : #evaluating }
MwTimeMethodWrapper >> afterMethod [

	self shouldNotImplement.
]

{ #category : #'derived accessing' }
MwTimeMethodWrapper >> averageTime [

	^ self count == 0
		ifTrue: [0]
		ifFalse: [self totalTime / self count asFloat]
]

{ #category : #evaluating }
MwTimeMethodWrapper >> beforeMethod [

	self shouldNotImplement.
]

{ #category : #initialization }
MwTimeMethodWrapper >> class: aClass selector: aSymbol [

	self time: 0.
	^ super class: aClass selector: aSymbol
]

{ #category : #'derived accessing' }
MwTimeMethodWrapper >> time [

	^ time
]

{ #category : #'derived accessing' }
MwTimeMethodWrapper >> time: anInteger [

	time := anInteger.
]

{ #category : #'derived accessing' }
MwTimeMethodWrapper >> totalTime [

	^ self time
]

{ #category : #evaluating }
MwTimeMethodWrapper >> valueWithReceiver: anObject arguments: argumentsArray [
	"This method was overriden so that recursive calls will have a different beginTime."

	| beginTime |
	beginTime := Time millisecondClockValue.
	self count: self count + 1.
	^ [
		self clientMethod valueWithReceiver: anObject arguments: argumentsArray
	] ensure: [self time: self time + (Time millisecondClockValue - beginTime max: 0)]
]
