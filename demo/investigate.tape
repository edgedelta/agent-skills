# Demo: incident triage flow (ed-investigate skill) - events, then patterns
Output assets/skill-investigate.gif
Set Shell "bash"
Set FontSize 15
Set Width 1200
Set Height 500
Set Padding 12
Set Theme "Catppuccin Mocha"
Set TypingSpeed 25ms

Type `edx events search -q 'event.type:"event_threshold"' --lookback 24h --limit 3 --output table --columns event_type,body`
Sleep 500ms
Enter
Sleep 3s
Type "edx patterns list --negative --limit 4 --output table --columns count,delta,sentiment,pattern"
Sleep 500ms
Enter
Sleep 4s
