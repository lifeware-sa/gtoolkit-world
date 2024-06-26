Extension { #name : #TelemetryLogger }

{ #category : #'*GToolkit-Profiler' }
TelemetryLogger >> gtFramesFor: aView [
	<gtView>
	^ aView explicit
		title: 'Frames';
		priority: 1;
		updateWhen: Announcement in: [ self announcer ];
		stencil: [ | aData anIndexMap |
			anIndexMap := (self recordings
					collectWithIndex: [ :eachSignal :eachIndex | eachSignal -> eachIndex ])
					asDictionary.

			aData := GtPlotterDataGroup new values: self recordings.
			aData := aData labelled: [ :eachTask | (anIndexMap at: eachTask) asString ].
			aData := aData
					background: [ :eachTask | 
						eachTask ping durationInMilliseconds <= 16
							ifTrue: [ BrGlamorousColors primaryBorderColor ]
							ifFalse: [ BrGlamorousColors errorBorderColor ] ].

			GtPlotter new horizontalBarChart
				with: aData;
				barGap: 0;
				groupSpacing: 0;
				barLabelSpacing: 40;
				barWidthData: [ :eachTask | eachTask ping durationInMilliseconds ];
				barWidthScale: (GtPlotterLinearScale new domainFrom: 0 to: 100.0);
				barHeightScale: (GtPlotterConstantScale new constant: 8);
				tickLabelFormat: [ :eachDuration | eachDuration asString , ' ms' ] ]
]
