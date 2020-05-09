#!/usr/bin/env tclsh

#DEPLOY folder
set deploypath DEPLOY

#file read
proc fsread {file} {
	set fs [open $file r]
	fconfigure $fs -encoding utf-8
	set data [read $fs]
	close $fs
	return $data
}

#file write
proc fswrite {file data} {
	set fs [open $file w]
	fconfigure $fs -encoding utf-8
	puts -nonewline $fs $data
	close $fs
}

#return %%NAVBAR%% content
proc navbarelement {mymatrix item} {
	set navbar_active "<li class=\"active\"><a href=\"#\">%%display%%</a></li>"
	set navbar_other "<li><a href=\"%%link%%.html\">%%display%%</a></li>"
	set string ""
	foreach index $mymatrix {
		foreach {fname display} $index {}
		if {$item == $fname} {set nav $navbar_active} {set nav $navbar_other}
		lappend string [string map [list %%link%% $fname %%display%% $display] $nav]
	}
	return [join $string "\n"]
}

#set template content
set templ [fsread body/template.html]

#page to deploy
#filename displayname
#move to fake to not deploy
set mymatrix [list \
{index Home} \
{about About} \
{gpg "GPG"} \
]
set fake [list \
{about About} \
{gpg "GPG"} \
]

#folder structure
set create_folder [list \
css \
js \
]

#file to be copied
set copy_files [list \
"css/main.css" \
"js/app.js" \
"js/particles.js" \
"js/particles.json" \
"js/particles.min.js" \
]

#if exist deploy folder redo it
if {[file exist $deploypath] && [file isdirectory $deploypath]} {file delete -force -- $deploypath}

#create folder structure
foreach item $create_folder {
	file mkdir $deploypath/$item
}

#copy file structure
foreach item $copy_files {
	file copy $item $deploypath/$item
}

#github CNAME file
#fswrite "$deploypath/CNAME" alberto.dietze.it

foreach index $mymatrix {
	foreach {fname display} $index {}
	#CSS LOAD
	if {[file exists "css/${fname}.css"]} {
		set css "\n\t<link rel=\"stylesheet\" media=\"screen\" href=\"css/${fname}.css\">"
		file copy "css/${fname}.css" "$deploypath/css/${fname}.css"
	} else {
		set css ""
	}
	#%%NAVBAR%%
	set nav [string map [list \n \n\t\t\t\t\t] [navbarelement $mymatrix $fname]]
	#load file
	set data [string map [list \n \n\t\t\t] [fsread "body/${fname}.html"]]
	#insert all in template
	set out [string map [list %%CSS%% $css %%NAVBAR%% $nav %%FILE%% $data] $templ]
	#write file
	fswrite "$deploypath/${fname}.html" $out
}
