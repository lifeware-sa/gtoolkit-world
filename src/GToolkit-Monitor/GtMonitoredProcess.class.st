Class {
	#name : #GtMonitoredProcess,
	#superclass : #GtMonitoredService,
	#category : #'GToolkit-Monitor'
}

{ #category : #'gt-extension' }
GtMonitoredProcess >> gtPSKeysFor: aView [
	<gtView>
	self service ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'PS Keys';
		priority: 5;
		object: [ self service ];
		view: #gtPSKeysFor:
]

{ #category : #'gt-extension' }
GtMonitoredProcess >> gtStackFor: aView [

	<gtView>
	^ aView explicit
		  title: 'Stack';
		  priority: 1;
		  stencil: [ 
			  (GtMethodContextsCoder forProcess: self service) forItems:
					  self stack ]
]

{ #category : #accessing }
GtMonitoredProcess >> gtTerminateActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons stop;
		tooltip: 'Terminate process';
		action: [ :aButton | self terminate ]
]

{ #category : #'gt-extension' }
GtMonitoredProcess >> gtUpdatingStackFor: aView [
	<gtView>
	^ aView explicit
		title: 'Updating stack';
		priority: 2;
		stencil: [ GtMonitoredProcessElement new service: self ]
]

{ #category : #testing }
GtMonitoredProcess >> isSuspended [
	<return: #Boolean>
	^ self service ifNotNil: [ :aService | aService isSuspended ] ifNil: [ false ]
]

{ #category : #testing }
GtMonitoredProcess >> isUserSnippet [
	<return: #Boolean>
	^ self service
		ifNotNil: [ :aService | (GtCoderUserSnippetDynamicVariable valueAtProcess: aService) isUserSnippet ]
		ifNil: [ false ]
]

{ #category : #accessing }
GtMonitoredProcess >> priority [
	<return: #Integer>
	^ self service ifNotNil: [ :aService | aService priority ] ifNil: [ 0 ]
]

{ #category : #accessing }
GtMonitoredProcess >> processIdAndContext [
	<return: #String>
	^ self service ifNotNil: [ :aProcess | 
			aProcess name, ': ', aProcess suspendedContext asString ]
]

{ #category : #accessing }
GtMonitoredProcess >> stack [
	<return: #Array or: #Context>
	^ self stackOfSize: 20
]

{ #category : #accessing }
GtMonitoredProcess >> stackOfSize: aStackDepth [
	<return: #Array or: #Context>
	| aProcess |
	aProcess := self service.
	aProcess ifNil: [ ^ #() ].
	^ aProcess == Processor activeProcess
		ifTrue: [ thisContext stackOfSize: aStackDepth ]
		ifFalse: [ aProcess suspendedContext stackOfSize: aStackDepth ]
]

{ #category : #accessing }
GtMonitoredProcess >> suspendedContext [
	<return: #Context or: nil>
	^ self service ifNotNil: [ :aService | aService suspendedContext ]
]

{ #category : #actions }
GtMonitoredProcess >> terminate [
	^ self service ifNotNil: #terminate
]

{ #category : #accessing }
GtMonitoredProcess >> title [
	<return: #String>
	^ self service ifNotNil: [ :aService | aService gtName ] ifNil: [ '' ]
]
