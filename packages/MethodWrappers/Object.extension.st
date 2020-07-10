Extension { #name : #Object }

{ #category : #'*MethodWrappers' }
Object >> isMwMethodWrapper [

	^ false
]

{ #category : #'*MethodWrappers' }
Object >> synchronize [

	MwSynchronizationWrapper installOnObject: self.
]

{ #category : #'*MethodWrappers' }
Object >> unsynchronize [

	^ self
]
