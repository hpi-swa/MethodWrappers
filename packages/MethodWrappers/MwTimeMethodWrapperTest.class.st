Class {
	#name : #MwTimeMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers-Tests'
}

{ #category : #running }
MwTimeMethodWrapperTest >> testAverageTime [

	| wrapper instance count |
	count := 10.
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	count timesRepeat: [instance methodDelay].
	self assert: wrapper count = count.
	self assert: (wrapper time / count asFloat) = wrapper averageTime.
	wrapper uninstall.
]

{ #category : #running }
MwTimeMethodWrapperTest >> testCounts [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper count = 0.
	instance methodDelay.
	self assert: wrapper count = 1.
	instance methodDelay.
	self assert: wrapper count = 2.
	wrapper uninstall.
]

{ #category : #running }
MwTimeMethodWrapperTest >> testCountsAndTimes [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper count = 0.
	self assert: wrapper time = 0.
	instance methodDelay.
	self assert: wrapper count = 1.
	self assert: wrapper time > 0.
	instance methodDelay.
	self assert: wrapper count = 2.
	self assert: wrapper time > 0.
	wrapper uninstall.
]

{ #category : #running }
MwTimeMethodWrapperTest >> testTimes [

	| wrapper instance previousTime |
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper time = 0.
	previousTime := wrapper time.
	instance methodDelay.
	self assert: wrapper time > previousTime.
	previousTime := wrapper time.
	instance methodDelay.
	self assert: wrapper time > previousTime.
	wrapper uninstall.
]

{ #category : #private }
MwTimeMethodWrapperTest >> wrapperClass [

	^ MwTimeMethodWrapper
]
