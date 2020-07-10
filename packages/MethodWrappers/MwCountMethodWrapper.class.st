"
A count method wrapper counts the number of times the method is called.

Inherited Class Instance Variables:

	wrapperInstVars	<WeakIdentityKeyDictionary
								key: MwCountMethodWrapper
								value: MwCountMethodWrapperInstVars>
							A kludge to add instance varibles to non-pointer classes.
"
Class {
	#name : #MwCountMethodWrapper,
	#superclass : #MwMethodWrapper,
	#instVars : [
		'count'
	],
	#category : #'MethodWrappers-Examples'
}

{ #category : #'class initialization' }
MwCountMethodWrapper class >> initialize [
	"doIt: [self initialize]"

	super initialize.
]

{ #category : #evaluating }
MwCountMethodWrapper >> beforeMethod [

	self count: self count + 1.
]

{ #category : #initialization }
MwCountMethodWrapper >> class: aClass selector: aSymbol [

	self count: 0.
	^ super class: aClass selector: aSymbol
]

{ #category : #'derived accessing' }
MwCountMethodWrapper >> count [

	^ count
]

{ #category : #'derived accessing' }
MwCountMethodWrapper >> count: anInteger [

	count := anInteger.
]
