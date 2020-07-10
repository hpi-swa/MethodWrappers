initialization
doesNotUnderstand: aMessage
	"required for all meta messages that need information from the original method"
	(self clientMethod isNil and: [aMessage selector == #flushCache]) ifTrue: [^ self].
	(self wrappedClass ~= self definingClass and: [aMessage selector == #methodClass:]) ifTrue: [^ self "Ignore silently. *sigh*"].
	^ aMessage sendTo: self clientMethod.