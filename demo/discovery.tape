# Demo: schema discovery before querying (ed-logs / ed-edx skill flow)
Output assets/skill-discovery.gif
Set Shell "bash"
Set FontSize 15
Set Width 1200
Set Height 500
Set Padding 12
Set Theme "Catppuccin Mocha"
Set TypingSpeed 25ms

Type "edx facets options --scope log --facet service.name --limit 4 --output table"
Sleep 500ms
Enter
Sleep 3s
Type `edx logs search -q 'service.name:"admin-api-deployment" AND severity_text:"ERROR"' --limit 4 --output table --columns severity_text,resource.service.name,resource.ed.tag`
Sleep 500ms
Enter
Sleep 4s
